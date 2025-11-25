import 'package:flutter/material.dart';
import 'package:lms_student/features/transript/models/course.dart';
import 'package:lms_student/features/transript/models/subject.dart';
import 'package:lms_student/features/transript/widgets/course_widget.dart';

class TranscriptPage extends StatelessWidget {
  TranscriptPage({super.key});
  static final routeName = '/transcriptpage';
  final List<TranscriptCourse> courses = [
    TranscriptCourse(
      name: 'English',
      credits: 40,
      subjects: [
        Subject(name: 'Eng 9A', completed: true),
        Subject(name: 'English 9B', completed: false),
        Subject(name: 'Eng 10A', completed: false),
        Subject(name: 'English 10B', completed: false),
        Subject(name: 'Contemp Compos.', completed: true),
        Subject(name: 'Contemp Compos.', completed: true),
        Subject(name: 'Amer. Lit.', completed: true),
        Subject(name: 'Expo Comp', completed: true),
        Subject(name: 'Eng. Elect.', completed: true),
      ],
    ),
    TranscriptCourse(
      name: 'Math',
      credits: 30,
      subjects: [
        Subject(name: 'Int. Math I A / Alg A', completed: true),
        Subject(name: 'Int. Math I B / Alg B', completed: false),
        Subject(name: 'Int. Math II A / Geom A', completed: false),
        Subject(name: 'Int. Math II B / Geom B', completed: false),
        Subject(name: 'Int. Math III A / Alg 2A', completed: true),
        Subject(name: 'Int. Math III B / Alg 2B', completed: true),
      ],
    ),
    TranscriptCourse(
      name: 'Social Sci',
      credits: 30,
      subjects: [
        Subject(name: 'World Hist A', completed: true),
        Subject(name: 'World Hist B', completed: false),
        Subject(name: 'US Hist A', completed: false),
        Subject(name: 'US Hist B', completed: false),
        Subject(name: 'US Government', completed: true),
        Subject(name: 'Economics', completed: true),
      ],
    ),
    TranscriptCourse(
      name: 'Sciences',
      credits: 20,
      subjects: [
        Subject(name: 'Biology A', completed: true),
        Subject(name: 'Biology B', completed: false),
        Subject(name: 'Earth Sci A', completed: false),
        Subject(name: 'Earth Sci B', completed: false),
        Subject(name: 'Chemistry A', completed: true),
        Subject(name: 'Chemistry B', completed: true),
        Subject(name: 'Marine Bio A', completed: true),
        Subject(name: 'Marine Bio B', completed: true),
      ],
    ),
    TranscriptCourse(
      name: 'Foreign Lang.',
      credits: 20,
      subjects: [
        Subject(name: 'Spanish 1A', completed: true),
        Subject(name: 'Spanish 1B', completed: false),
        Subject(name: 'Spanish 2A', completed: false),
        Subject(name: 'Spanish 2B', completed: false),
      ],
    ),
    TranscriptCourse(
      name: 'Visual/Perf Arts',
      credits: 10,
      subjects: [
        Subject(name: 'Digital Imaging A', completed: true),
        Subject(name: 'Digital Imaging B', completed: false),
      ],
    ),
    TranscriptCourse(
      name: 'Personal/Career Dev',
      credits: 20,
      subjects: [
        Subject(name: 'Success Seminar 1A', completed: true),
        Subject(name: 'Success Seminar 1B', completed: false),
        Subject(name: 'Success Seminar 2A', completed: true),
        Subject(name: 'Success Seminar 2B', completed: false),
      ],
    ),
    TranscriptCourse(
      name: 'Electives',
      credits: 40,
      subjects: [
        Subject(
          name: 'Advanced courses within A-Gareas including dual enrollment',
          completed: true,
        ),
        Subject(name: '1', completed: false),
        Subject(name: '2', completed: true),
        Subject(name: '3', completed: false),
        Subject(name: '4', completed: true),
        Subject(name: '5', completed: false),
        Subject(name: '6', completed: false),
        Subject(name: '7', completed: false),
        Subject(name: '8', completed: false),
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transcript')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Full A-G HS Diploma',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) =>
                    TranscriptCourseWidget(course: courses[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
