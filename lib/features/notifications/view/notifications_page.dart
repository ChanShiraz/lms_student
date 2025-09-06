import 'package:flutter/material.dart';
import 'package:lms_student/features/notifications/widgets/notification_widget.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  static final routeName = '/notificationspage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Text(
              'RECENTLY GRADED',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          NotificationWidget(),
        ],
      ),
    );
  }
}
