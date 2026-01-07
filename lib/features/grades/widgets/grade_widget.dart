import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:lms_student/features/grades/models/grade.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/home/models/course.dart';
import 'package:lms_student/features/home/services/grades_helper.dart';
import 'package:lms_student/features/summatives/view/summative_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GradeWidget extends StatelessWidget {
  GradeWidget({super.key, required this.course});
  final Course course;
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final label = GradeHelper.getGradeLabel(
      //course.title!,
      course.grade ?? 0.0,
      course.graduated ?? 0,
      course.incomplete ?? 1,
    );
    final color = GradeHelper.getGradeColor(label);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: () => Get.toNamed(SummativePage.routeName, arguments: course),
        child: Material(
          elevation: 0.5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    course.img != null
                        ? Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: course.img!,
                                height: 60,
                              ),
                            ),
                          )
                        : SizedBox(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        FutureBuilder<String>(
                          future: course.courseStatus(
                            homeController.userModel.userId!,
                          ), // this returns Future<String>
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                "Loading...",
                                style: TextStyle(color: Colors.grey),
                              );
                            }
                            if (snapshot.hasError) {
                              return Text(
                                "Error",
                                style: TextStyle(color: Colors.red),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text(
                                "No Status",
                                style: TextStyle(color: Colors.grey),
                              );
                            }

                            final status = snapshot.data!;
                            Color statusColor;
                            if (status.contains(GradeStatus.completed)) {
                              statusColor = Colors.green;
                            } else if (status.contains(
                              GradeStatus.inProgress,
                            )) {
                              statusColor = Colors.blue;
                            } else {
                              statusColor = Colors.red;
                            }
                            return RichText(
                              text: TextSpan(
                                text: status,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: statusColor,
                                ),
                              ),
                            );
                          },
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'Grade: '),
                              TextSpan(
                                text: label,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                course.grade! != 7 &&
                        (course.grade! >= 2.5 || course.grade! == 8) &&
                        course.incomplete == 0 &&
                        course.graduated == 1
                    ? CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.done_rounded, color: Colors.white),
                      )
                    : FutureBuilder<num>(
                        future: GradeHelper.calculateCompletionPercentage(
                          couresType: course.courseType!,
                          userId: homeController
                              .userModel
                              .userId!, // pass actual userId
                          aCid: course.cid,
                          schoolId: homeController.userModel.schoolId!,
                          currentLearningYear: homeController
                              .currentLearningYear, // pass actual course ID
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          }

                          if (snapshot.hasError) {
                            // On error, fallback to a red error icon
                            return const CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Icon(Icons.error, color: Colors.white),
                            );
                          }

                          // Safely get the completion value
                          final completion = snapshot.data ?? 0;

                          // If completion is 100%, show green checkmark
                          if (completion == 100) {
                            return const CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.done_rounded,
                                color: Colors.white,
                              ),
                            );
                          }

                          // Otherwise, show circular progress with percentage
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 36,
                                height: 36,
                                child: CircularProgressIndicator(
                                  value: completion.toDouble() / 100,
                                  backgroundColor: Colors.grey.shade300,
                                  color: completion == 0
                                      ? Colors.red
                                      : completion < 100
                                      ? Colors.blue
                                      : Colors.green,
                                  strokeWidth: 3,
                                ),
                              ),
                              Center(
                                child: Text(
                                  '$completion%',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
