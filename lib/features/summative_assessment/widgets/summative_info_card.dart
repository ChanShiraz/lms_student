import 'package:flutter/material.dart';
import 'package:lms_student/common/round_container.dart';

class SummativeInfoCard extends StatelessWidget {
  const SummativeInfoCard({super.key, required this.title, required this.task});
  //final LessonFormative formative;
  final String title;
  final String task;

  @override
  Widget build(BuildContext context) {
    return RoundContainer(
      color: Colors.white,
      circular: 25,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RoundContainer(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Task : ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(text: task),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        RoundContainer(
          color: Colors.grey.shade50,
          circular: 12,
          padding: 8,
          child: Icon(Icons.info_outline, size: 20),
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
