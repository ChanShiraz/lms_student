// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';

import 'package:lms_student/features/messages/controllers/chat_page_repo.dart';
import 'package:lms_student/features/messages/models/message_model.dart';

class ChatController extends GetxController {
  final repo = ChatPageRepo();
  final String threadId;
  ChatController({required this.threadId});
  final homeController = Get.find<HomeController>();
  TextEditingController messageBodyController = TextEditingController();

  void findDirectThread() async {
    await repo.markThreadAsRead(
      threadId: threadId,
      userId: homeController.userModel.userId!,
    );
    await loadMessages();
    repo.subscribeToMessages(
      thread: threadId,
      onCallBack: (msg) {
        repo.markThreadAsRead(
          threadId: threadId,
          userId: homeController.userModel.userId!,
        );
        messages.add(msg);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom(animated: true);
        });
      },
    );
  }

  Future<void> sendMessage({required String body}) async {
    try {
      await repo.sendMessage(threadId: threadId, body: body);
      scrollToBottom();
      //debugPrint('Message sent!');
    } catch (e) {
      debugPrint('Error sending message $e');
    }
  }

  void unsubsribeMessages() {
    repo.unsubscribeMessage();
  }
  //chat message

  // RxList<MessageModel> messages = <MessageModel>[].obs;
  // Future<void> loadMessages() async {
  //   final res = await repo.fetchMessages(threadId);
  //   messages.assignAll(res.map((e) => MessageModel.fromMap(e)).toList());
  // }
  static const int pageSize = 25;
  RxBool loadingMore = false.obs;
  RxBool hasMoreMessages = true.obs;
  int page = 0; // 0 = latest messages
  RxList<MessageModel> messages = <MessageModel>[].obs;
  Future<void> loadMessages({bool loadMore = false}) async {
    if (!loadMore) {
      page = 0;
      hasMoreMessages.value = true;
    }
    if (loadMore && (loadingMore.value || !hasMoreMessages.value)) return;
    loadingMore.value = true;
    final res = await repo.fetchMessagesByPage(
      threadId: threadId,
      limit: pageSize,
      offset: page * pageSize,
    );
    final fetched = res.map((e) => MessageModel.fromMap(e)).toList();
    if (fetched.length < pageSize) {
      hasMoreMessages.value = false;
    }
    if (loadMore) {
      // Older messages → prepend
      messages.insertAll(0, fetched.reversed.toList());
    } else {
      // Latest messages
      messages.assignAll(fetched.reversed.toList());
      scrollToBottom(animated: false);
    }
    page++;
    loadingMore.value = false;
  }

  final ScrollController scrollController = ScrollController();
  void scrollToBottom({bool animated = true}) {
    if (!scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final position = scrollController.position.maxScrollExtent;
      if (animated) {
        scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      } else {
        scrollController.jumpTo(position);
      }
    });
  }
}
