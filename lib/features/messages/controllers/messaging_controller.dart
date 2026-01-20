import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/messages/controllers/chat_page_repo.dart';
import 'package:lms_student/features/messages/models/chat_course_model.dart';
import 'package:lms_student/features/messages/models/chat_thread.dart';
import 'package:lms_student/features/messages/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessagingController extends GetxController {
  final supabase = Supabase.instance.client;
  final repo = ChatPageRepo();
  Rx<ChatCourseModel?> selectedCourse = Rx<ChatCourseModel?>(null);
  //Rx<Student?> selectedStudent = Rx<Student?>(null);
  Rx<ChatThread?> selectedThread = Rx<ChatThread?>(null);
  final homeController = Get.find<HomeController>();
  //final user = Get.find<UserController>().currentUser.value;

  RxList<ChatThread> threads = <ChatThread>[].obs;
  RxBool fetchingThreads = false.obs;

  void fetchThreads() async {
    fetchingThreads.value = true;
    try {
      threads.value = await repo.fetchChatThreads(
        homeController.userModel.userId!,
      );
      repo.subscribeToThreads(threads: threads);
    } catch (e) {
      debugPrint('Error fetching chat threads $e');
    }
    fetchingThreads.value = false;
  }

  void resetSelection() {
    selectedCourse.value = null;
    // selectedStudent.value = null;
    selectedThread.value = null;
  }

  Future<void> createChatThread({
    required int otherUserId,
    required String title,
  }) async {
    try {
      selectedThread.value = await repo.createDirectThread(
        otherUserId: otherUserId,
        title: title,
      );
      // messages.clear();
      // findDirectThread();
    } catch (e) {
      debugPrint('Error creating thread $e');
    }
  }
}
