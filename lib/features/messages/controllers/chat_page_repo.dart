import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/messages/models/chat_course_model.dart';
import 'package:lms_student/features/messages/models/chat_thread.dart';
import 'package:lms_student/features/messages/models/message_model.dart';
import 'package:lms_student/features/messages/models/thread_types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPageRepo {
  final supabase = Supabase.instance.client;
  // final user = Get.find<UserController>().currentUser.value;
  // final learningYear = Get.find<UserController>().learningYear;
  final homeController = Get.find<HomeController>();

  Future<List<ChatThread>> fetchChatThreads(int currentUserId) async {
    final res = await supabase
        .from('chat_threads')
        .select()
        // .eq('kind', 'direct')
        .contains('participants', [currentUserId])
        .order('last_message_at');
    if (res.isEmpty) return [];
    final threads = await Future.wait(
      res.map((e) async {
        final unread = await fetchThreadUnreadCount(e['thread_id']);

        return ChatThread.fromMap(
          e,
          unread,
          e['kind'] == ThreadType.direct
              ? await getUserName(List<int>.from(e['participants']))
              : null,
        );
      }),
    );

    return threads;
    //return res.map((e) => ChatThread.fromMap(e,)).toList();
  }

  RealtimeChannel? _threadChannel;
  void subscribeToThreads({required RxList<ChatThread> threads}) {
    _threadChannel?.unsubscribe();
    _threadChannel = supabase
        .channel('chat_threads_realtime')
        .onPostgresChanges(
          schema: 'public',
          table: 'chat_threads',
          event: PostgresChangeEvent.all, // 👈 INSERT + UPDATE
          callback: (payload) async {
            homeController.refreshUnreadCount();
            final data = payload.newRecord;
            final participants = List<int>.from(data['participants'] ?? []);
            // 👇 Manual filter (IMPORTANT)
            if (!participants.contains(homeController.userModel.userId!))
              return;
            final unread = await fetchThreadUnreadCount(data['thread_id']);
            final thread = ChatThread.fromMap(
              data,
              unread,
              data['kind'] == ThreadType.direct
                  ? await getUserName(List<int>.from(data['participants']))
                  : null,
            );
            final index = threads.indexWhere(
              (t) => t.thread_id == thread.thread_id,
            );
            if (index == -1) {
              // New thread
              threads.add(thread);
            } else {
              // Existing thread updated
              threads[index] = thread;
            }

            // Optional: keep sorted by last message
            threads.sort(
              (a, b) => b.last_message_at.compareTo(a.last_message_at),
            );
          },
        )
        .subscribe();
  }

  Future<int> fetchThreadUnreadCount(String threadId) async {
    final res = await supabase.rpc(
      'get_thread_unread_count',
      params: {
        'p_thread_id': threadId,
        'p_user_id': homeController.userModel.userId!,
      },
    );
    return res as int;
  }

  Future<String?> findDirectThread({
    required int currentUserId,
    required int otherUserId,
  }) async {
    final res = await supabase
        .from('chat_threads')
        .select('thread_id, participants')
        .eq('kind', 'direct')
        .contains('participants', [currentUserId, otherUserId])
        .limit(1);

    if (res.isEmpty) return null;

    // Extra safety check (recommended)
    final participants = List<int>.from(res.first['participants']);
    if (participants.length != 2) return null;

    return res.first['thread_id'] as String;
  }

  Future<ChatThread> createDirectThread({
    required int otherUserId,
    required String title,
  }) async {
    final currentUserId = homeController.userModel.userId!;

    // 1️⃣ Check if direct thread already exists
    final existing = await supabase
        .from('chat_threads')
        .select()
        .eq('kind', 'direct')
        .contains('participants', [currentUserId, otherUserId])
        .maybeSingle();
    if (existing != null) {
      return ChatThread.fromMap(
        existing,
        0,

        await getUserName(List<int>.from(existing['participants'])),
      );
    }

    // 2️⃣ Create new thread
    final res = await supabase
        .from('chat_threads')
        .insert({
          'kind': 'direct',
          'participants': [currentUserId, otherUserId],
          'created_by': currentUserId,
          'last_message_at': DateTime.now().toIso8601String(),
          'title': title,
        })
        .select()
        .single();
    return ChatThread.fromMap(
      res,
      0,
      await getUserName(List<int>.from(res['participants'])),
    );
  }

  Future<void> sendMessage({
    required String threadId,
    required String body,
  }) async {
    await supabase.from('chat_messages').insert({
      'thread_id': threadId,
      'sender_userid': homeController.userModel.userId!,
      'body': body,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Optional but recommended
    await supabase
        .from('chat_threads')
        .update({
          'last_message_at': DateTime.now().toIso8601String(),
          'last_message': body,
        })
        .eq('thread_id', threadId);
  }

  Future<List<Map<String, dynamic>>> fetchMessagesByPage({
    required String threadId,
    required int limit,
    required int offset,
  }) async {
    return await supabase
        .from('chat_messages')
        .select()
        .eq('thread_id', threadId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);
  }

  RealtimeChannel? _channel;
  void subscribeToMessages({
    String? thread,
    // required RxList<MessageModel> messages,
    required void Function(MessageModel) onCallBack,
  }) {
    if (thread == null) return;
    _channel?.unsubscribe(); // safety
    _channel = supabase
        .channel('chat:$thread')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'thread_id',
            value: thread,
          ),
          callback: (payload) {
            final message = MessageModel.fromMap(payload.newRecord);
            onCallBack(message); // controller decides what to do
          },
        )
        .subscribe();
  }

  void unsubscribeMessage() {
    _channel?.unsubscribe();
  }

  Future<void> markThreadAsRead({
    required String threadId,
    required int userId,
  }) async {
    await supabase.from('chat_thread_reads').upsert({
      'thread_id': threadId,
      'user_id': userId,
      'last_read_at': DateTime.now().toIso8601String(),
    });
    homeController.refreshUnreadCount();
  }

  Future<String?> getUserName(List<int> ids) async {
    String? name;
    final int otherUserId = ids.firstWhere(
      (id) => id != homeController.userModel.userId,
    );
    final res = await supabase
        .from('users')
        .select('first,last')
        .eq('userid', otherUserId)
        .maybeSingle();
    if (res != null) {
      name = '${res['first']} ${res['last']}';
    }
    return name;
  }
}
