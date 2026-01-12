import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lms_student/common/round_container.dart';
import 'package:lms_student/common/shimmer_tile.dart';
import 'package:lms_student/features/formative_assessment/models/formative_submission.dart';
import 'package:lms_student/features/formative_assessment/view/fa_input_page.dart';
import 'package:lms_student/features/formative_assessment/view/fa_link_page.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/learning_journey/models/lesson.dart';
import 'package:lms_student/features/summative_assessment/models/summative_submission.dart';

class FormativeFeedbackCard extends StatelessWidget {
  const FormativeFeedbackCard({
    super.key,
    required this.submission,
    required this.isLoading,
    required this.journey,
    required this.lesson,
    required this.lessonFormative,
  });
  final FormativeSubmission? submission;
  final bool isLoading;
  final Journey journey;
  final Lesson lesson;
  final LessonFormative lessonFormative;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    if (lessonFormative.status == 0) {
      return RoundContainer(
        color: Colors.white,
        child: Text('Formative pending by by teacher'),
      );
    }
    return isLoading
        ? ShimmerTile(width: double.infinity, height: height / 5)
        : submission != null && submission!.comment != null
        ? RoundContainer(
            color: Colors.white,
            circular: 25,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  SizedBox(height: 12),
                  RoundContainer(
                    width: double.infinity,
                    color: Colors.grey.shade50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Feedback by ${submission!.assessBy}',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        Text(
                          submission!.comment ?? '',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),

                  submission != null && submission!.status == 2
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                onPressed: () {
                                  Get.toNamed(
                                    FaLinkPage.routeName,
                                    arguments: [
                                      lesson,
                                      journey,
                                      lessonFormative,
                                    ],
                                  );
                                },
                                label: Text('Link'),
                                icon: Icon(Icons.add_link),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                onPressed: () {
                                  Get.toNamed(
                                    FaInputPage.routeName,
                                    arguments: [
                                      lesson,
                                      journey,
                                      lessonFormative,
                                    ],
                                  );
                                },
                                label: Text('Direct Input'),
                                icon: Icon(Icons.note_add_outlined),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          )
        : SizedBox();
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            RoundContainer(
              color: Colors.grey.shade50,
              circular: 12,
              padding: 8,
              child: Icon(Icons.messenger_outline, size: 20),
            ),
            SizedBox(width: 10),
            const Text(
              'Feedback',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.messenger_outline, color: Colors.white),
              SizedBox(width: 10),
              const Text('Message Teacher'),
            ],
          ),
        ),
      ],
    );
  }
}
