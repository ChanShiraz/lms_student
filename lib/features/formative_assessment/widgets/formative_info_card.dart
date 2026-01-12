import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lms_student/common/round_container.dart';
import 'package:lms_student/features/learning_journey/models/lesson.dart';
import 'package:lms_student/features/learning_journey/view/prior_knowledge_page.dart';
import 'package:lms_student/features/summative_assessment/widgets/text_dialog.dart';

class FormativeInfoCard extends StatelessWidget {
  const FormativeInfoCard({
    super.key,
    required this.title,
    required this.desc,
    required this.type,
    this.link,
    this.text,
  });
  //final LessonFormative formative;
  final String title;
  final String desc;
  final int type;
  final String? link;
  final String? text;

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
            child: RoundContainer(child: Text(desc)),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
        ),
        ElevatedButton.icon(
          onPressed: () {
            if (type == 2 && link != null && link!.isNotEmpty) {
              launchMyUrl(link!);
            } else if (type == 4) {
              showDialog(
                context: context,
                builder: (context) => TextDialog(initialText: text),
              );
            }
          },
          icon: Icon(type == 2 ? Icons.link : Icons.text_snippet_outlined),
          label: const Text('View'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
