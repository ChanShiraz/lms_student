import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:lms_student/features/messages/models/messaging.dart';
import 'package:lms_student/features/messages/view/chat_page.dart';

class MessagingPage extends StatelessWidget {
  MessagingPage({super.key});
  static final routeName = '/messagingpage';
  final List<Messaging> messages = [
    Messaging('assets/images/journey.jpeg', 'English 9A', 'Mr. Elisworth', 1),
    Messaging('assets/images/journey.jpeg', 'Integrated Math', 'Ms. Leon', 1),
    Messaging('assets/images/journey.jpeg', 'Biology A', 'Mr. Jenning', 1),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messaging'), centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) => ListTile(
            onTap: () => Get.toNamed(ChatPage.routeName),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(messages[index].courseIcon),
            ),
            title: Text(messages[index].courseTitle),
            subtitle: Text('Send Messages to: ${messages[index].teacher}'),
            trailing: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 15,
              child: Icon(Icons.message_rounded, color: Colors.white, size: 15),
            ),
          ),
        ),
      ),
    );
  }
}
