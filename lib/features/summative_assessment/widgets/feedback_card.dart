import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:lms_student/common/round_container.dart';
import 'package:lms_student/common/shimmer_tile.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/summative_assessment/controller/summative_assessment_controller.dart';
import 'package:lms_student/features/summative_assessment/view/sa_input_page.dart';
import 'package:lms_student/features/summative_assessment/view/sa_link_page.dart';

class FeedbackCard extends StatelessWidget {
  FeedbackCard({super.key, required this.journey});
  final Journey journey;
  final controller = Get.find<SummativeAssessmentController>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Obx(() {
      if (controller.fetchingSubSummative.value) {
        return ShimmerTile(width: double.infinity, height: height / 5);
      }
      if (controller.submittedSummative.value != null &&
          controller.submittedSummative.value!.status != 0) {
        return RoundContainer(
          color: Colors.white,
          circular: 25,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 12),
                RoundContainer(
                  width: double.infinity,
                  color: Colors.grey.shade50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Feedback by ${controller.submittedSummative.value!.assessBy}',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      Text(
                        controller.submittedSummative.value!.comment!,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                controller.submittedSummative.value != null &&
                        controller.submittedSummative.value!.status == 2
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
                                  SaLinkPage.routeName,
                                  arguments: journey,
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
                                  SaInputPage.routeName,
                                  arguments: journey,
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
        );
      }
      if (controller.submittedSummative.value != null &&
          controller.submittedSummative.value!.status == 0) {
        return RoundContainer(
          color: Colors.white,
          child: Text('Summative Pending By Teacher'),
        );
      }
      return SubmitButtons(journey: journey);
    });
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

class SubmitButtons extends StatelessWidget {
  const SubmitButtons({super.key, required this.journey});
  final Journey journey;
  @override
  Widget build(BuildContext context) {
    return RoundContainer(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RoundContainer(
                color: Colors.grey.shade50,
                circular: 12,
                padding: 8,
                child: Icon(Icons.add_task_rounded, size: 20),
              ),
              SizedBox(width: 10),
              Text(
                'Submit Summative',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  Get.toNamed(SaLinkPage.routeName, arguments: journey);
                },
                label: Text('Link'),
                icon: Icon(Icons.add_link),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  Get.toNamed(SaInputPage.routeName, arguments: journey);
                },
                label: Text('Direct Input'),
                icon: Icon(Icons.note_add_outlined),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
