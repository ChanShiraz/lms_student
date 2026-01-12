import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms_student/common/custom_appbar.dart';
import 'package:lms_student/features/formative_assessment/widgets/formative_info_card.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/summative_assessment/controller/summative_assessment_controller.dart';
import 'package:lms_student/features/summative_assessment/widgets/feedback_card.dart';
import 'package:lms_student/features/summative_assessment/widgets/overview_card.dart';
import 'package:lms_student/features/summative_assessment/widgets/quick_details_card.dart';
import 'package:lms_student/features/summative_assessment/widgets/summative_info_card.dart';
import 'package:lms_student/features/summative_assessment/widgets/timeline_card.dart';

class SummativeAssessmentPage extends StatefulWidget {
  const SummativeAssessmentPage({super.key, required this.journey});
  final Journey journey;
  static final routeName = '/summativeassessmentpage';

  @override
  State<SummativeAssessmentPage> createState() =>
      _SummativeAssessmentPageState();
}

class _SummativeAssessmentPageState extends State<SummativeAssessmentPage> {
  final controller = Get.put(SummativeAssessmentController());
  @override
  void initState() {
    controller.fetchSubmittedSummative(widget.journey.dmodSumId);
    controller.fetchSummativeLesson(widget.journey.dmodSumId);
    controller.fetchResources(widget.journey.dmodSumId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Summative Assessment',
        subtitle: '${controller.homeController.userModel.first} · Summative',
      ),
      //SummativeAppBar(),
      backgroundColor: Colors.grey.shade50,
      //const Color(0xFFF6F8FC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Wrap(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Assessor: ',
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextSpan(
                              text: widget.journey.assessedBy,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Course: ',
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextSpan(
                              text: widget.journey.courseTitle,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Summative: ',
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextSpan(
                              text: widget.journey.title,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: SummativeInfoCard(
                title: widget.journey.title,
                task: widget.journey.task,
              ),
            ),
            isMobileLayout(context)
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        OverviewCard(
                          controller: controller,
                          journey: widget.journey,
                        ),
                        SizedBox(height: 16),
                        FeedbackCard(journey: widget.journey),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              OverviewCard(
                                controller: controller,
                                journey: widget.journey,
                              ),
                              SizedBox(height: 16),
                              FeedbackCard(journey: widget.journey),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              TimelineCard(),
                              SizedBox(height: 16),
                              QuickDetailsCard(journey: widget.journey),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

bool isMobileLayout(BuildContext context) =>
    MediaQuery.of(context).size.width < 600;
