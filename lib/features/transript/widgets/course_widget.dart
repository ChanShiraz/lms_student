import 'package:flutter/material.dart';
import 'package:lms_student/features/transript/models/course.dart';
import 'package:lms_student/features/transript/models/subject.dart';
import 'package:lms_student/features/transript/view/transcript_page.dart';

class TranscriptCourseWidget extends StatelessWidget {
  const TranscriptCourseWidget({super.key, required this.course});
  final TranscriptCourse course;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            shape: Border(),
            tilePadding: EdgeInsets.zero,
            trailing: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 10,
              child: Icon(Icons.done_rounded, size: 15, color: Colors.white),
            ),
            title: Text(
              '${course.name} - ${course.credits} Credits',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            children: [
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: course.subjects.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  mainAxisExtent: 40,
                ),
                itemBuilder: (context, index) =>
                    SubjectWidget(subject: course.subjects[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectWidget extends StatelessWidget {
  const SubjectWidget({super.key, required this.subject});
  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.scale(
            scale: 0.8,
            child: Checkbox(
              value: subject.completed,
              onChanged: (value) {},
              side: BorderSide(color: Colors.black38, width: 2),
              activeColor: Colors.green,
              checkColor: Colors.white,
            ),
          ),
          Flexible(child: Text(subject.name, style: TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
