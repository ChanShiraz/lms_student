import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:lms_student/features/messages/controllers/messaging_controller.dart';
import 'package:lms_student/features/messages/models/messaging.dart';
import 'package:lms_student/features/messages/view/chat_page.dart';
import 'package:lms_student/features/messages/widgets/new_chat_dialog.dart';
import 'package:lms_student/features/messages/widgets/thread_list.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({super.key});
  static final routeName = '/messagingpage';

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  final controller = Get.put(MessagingController());
  @override
  void initState() {
    controller.fetchThreads();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Messaging'), centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            Obx(
              () => Expanded(
                child: ThreadsList(
                  isLoading: controller.fetchingThreads.value,
                  //course: controller.selectedCourse.value!,
                  threads: controller.threads.value,
                  onBack: controller.resetSelection,
                  selectedId: controller.selectedThread.value?.thread_id,
                  onSelect: (thread) {
                    thread.unreadCount = 0;
                    controller.threads.refresh();
                    Get.to(ChatPage(chatThread: thread));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showDialog(context: context, builder: (context) => NewChatDialog());
        },
      ),
    );
  }
}
