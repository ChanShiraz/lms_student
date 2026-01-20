import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms_student/features/courses/controllers/courses_controller.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/messages/models/chat_thread.dart';
import 'package:lms_student/features/messages/models/people.dart';
import 'package:lms_student/features/messages/view/chat_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewChatController extends GetxController {
  final homeController = Get.find<HomeController>();
  final supabase = Supabase.instance.client;
  final coursesController = Get.find<CoursesController>();

  RxList<People> peoples = <People>[].obs;
  RxBool fetchingPeople = false.obs;

  void fetchPeoples() async {
    fetchingPeople.value = true;
    peoples.value = [];
    try {
      for (var element in coursesController.courses) {
        final res = await supabase
            .from('users')
            .select('first,last,userid')
            .eq('userid', element.userid_assigned)
            .maybeSingle();
        if (res != null) {
          peoples.add(People.fromMap(res));
        }
      }
    } catch (e) {
      debugPrint('error fetching students $e');
    }
    fetchingPeople.value = false;
  }

  Future<void> createDirectChatThread({
    required int otherUserId,
    //required String title,
  }) async {
    try {
      ChatThread chatThread = await getOrCreateDirectThread(
        otherUserId: otherUserId,
        title:
            '${homeController.userModel.first} ${homeController.userModel.last}',
      );
      //Get.to(ChatPage(chatThread: chatThread));
      // chatPageController.messages.clear();
      // chatPageController.findDirectThread();
    } catch (e) {
      debugPrint('Error creating thread $e');
    }
  }

  Future<ChatThread> getOrCreateDirectThread({
    required int otherUserId,
    required String title,
  }) async {
    final existing = await findDirectThread(
      currentUserId: homeController.userModel.userId!,
      otherUserId: otherUserId,
    );
    print('existing thread $existing');
    if (existing != null) {
      return existing;
    }
    return await createDirectThread(otherUserId: otherUserId, title: title);
  }

  Future<ChatThread> createDirectThread({
    required int otherUserId,
    required String title,
  }) async {
    final res = await supabase
        .from('chat_threads')
        .insert({
          'kind': 'direct',
          'participants': [homeController.userModel.userId, otherUserId],
          'created_by': homeController.userModel.userId,
          'last_message_at': DateTime.now().toIso8601String(),
          'title': title,
        })
        .select()
        .single();

    return ChatThread.fromMap(res, 0, null);
  }

  Future<ChatThread?> findDirectThread({
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

    return ChatThread.fromMap(res.first, 0, null);
  }
}
