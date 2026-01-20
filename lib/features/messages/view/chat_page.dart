import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:lms_student/common/custom_appbar.dart';
import 'package:lms_student/features/messages/controllers/chat_controller.dart';
import 'package:lms_student/features/messages/controllers/messaging_controller.dart';
import 'package:lms_student/features/messages/models/chat_thread.dart';
import 'package:lms_student/features/messages/models/thread_types.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.chatThread});
  final ChatThread chatThread;
  static final routeName = '/chatpage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatController controller;
  final messagingController = Get.find<MessagingController>();
  @override
  void initState() {
    controller = Get.put(ChatController(threadId: widget.chatThread.thread_id));
    controller.findDirectThread();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onBackPressed: () {
          controller.unsubsribeMessages();
          Get.back();
        },
        title: widget.chatThread.kind == ThreadType.direct
            ? widget.chatThread.userName ?? ''
            : widget.chatThread.title ?? '',
        subtitle:
            widget.chatThread.kind == ThreadType.course ||
                widget.chatThread.courseTitle != null
            ? widget.chatThread.courseTitle
            : null,
      ),

      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return LoadOlderMessagesListItem(controller: controller);
                    }
                    final msg = controller.messages[index - 1];
                    return _buildMessageBubble(
                      msg.text,
                      controller.homeController.userModel.userId ==
                          msg.senderId,
                    );
                  },
                ),
              ),
            ),
          ),
          widget.chatThread.kind == ThreadType.direct
              ? _buildMessageInput()
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // if (!isMe)
        //   const CircleAvatar(
        //     radius: 18,
        //     backgroundImage: AssetImage('assets/images/user1.png'),
        //   ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints: const BoxConstraints(maxWidth: 250),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isMe
                  ? const Radius.circular(12)
                  : const Radius.circular(0),
              bottomRight: isMe
                  ? const Radius.circular(0)
                  : const Radius.circular(12),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(color: isMe ? Colors.white : Colors.black),
          ),
        ),
        // if (isMe)
        //   const CircleAvatar(
        //     radius: 18,
        //     backgroundImage: AssetImage('assets/images/user2.png'),
        //   ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller.messageBodyController,
                textInputAction: TextInputAction.send, // Enter key shows "Send"
                onSubmitted: (_) {
                  final text = controller.messageBodyController.text.trim();
                  if (text.isEmpty) return;
                  controller.sendMessage(body: text);
                  controller.messageBodyController.clear();
                },
                decoration: InputDecoration(
                  hintText: "Type a message",
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              final text = controller.messageBodyController.text.trim();
              if (text.isEmpty) return;
              controller.sendMessage(body: text);
              controller.messageBodyController.clear();
            },
          ),
        ],
      ),
    );
  }
}

class LoadOlderMessagesListItem extends StatelessWidget {
  final ChatController controller;

  const LoadOlderMessagesListItem({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.hasMoreMessages.value) {
        return const SizedBox(height: 0);
      }

      return Center(
        child: SizedBox(
          width: 160,
          child: OutlinedButton(
            onPressed: controller.loadingMore.value
                ? null
                : () => controller.loadMessages(loadMore: true),
            child: controller.loadingMore.value
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Older messages', textAlign: TextAlign.center),
          ),
        ),
      );
    });
  }
}
