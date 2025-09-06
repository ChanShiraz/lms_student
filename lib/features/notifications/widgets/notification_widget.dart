import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(Icons.biotech, color: Colors.white),
      ),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Biology A',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: ' - Summative',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Proficient',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          ),
          Text('Graded 4/22/2024', style: TextStyle(fontSize: 12)),
        ],
      ),
      trailing: Icon(Icons.done_rounded, color: Colors.green),
    );
  }
}
