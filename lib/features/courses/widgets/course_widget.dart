import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/home/models/course.dart';
import 'package:lms_student/features/home/services/grades_helper.dart';
import 'package:lms_student/features/home/widgets/course_widget.dart';
import 'package:lms_student/services/courses_helper.dart';
import 'package:shimmer/shimmer.dart';

class CourseWidget extends StatelessWidget {
  const CourseWidget({super.key, required this.course, required this.onTap});
  final Course course;
  final VoidCallback onTap;
  //final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    // CoursesHelper.getCourseLp(
    //   cid: course.cid,
    //   couresType: course.courseType!,
    //   currentLearningYear: homeController.currentLearningYear,
    //   schoolId: homeController.userModel.schoolId!,
    //   userId: homeController.userModel.userId!,
    // );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [SubjectDetails(course: course, onTap: onTap)],
            ),
          ),
        ),
      ),
    );
  }
}

class SubjectDetails extends StatelessWidget {
  SubjectDetails({super.key, required this.course, required this.onTap});
  final Course course;
  final VoidCallback onTap;
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
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                              height: 50,
                              errorWidget: (context, url, error) => SizedBox(),
                            ),
                          ),
                        )
                      : SizedBox(),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title ?? '',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${CoursesHelper.courseType(course.courseType ?? 0)} ${course.teacher}',
                      ),
                    ],
                  ),
                ],
              ),

              course.grade! != 7 &&
                      (course.grade! >= 2.5 || course.grade! == 8) &&
                      course.incomplete == 0 &&
                      course.graduated == 1
                  ? CompletionBadge(completion: 100)
                  : Column(
                      children: [
                        FutureBuilder<num>(
                          future: GradeHelper.calculateCompletionPercentage(
                            userId: homeController.userModel.userId!,
                            aCid: course.cid,
                            schoolId: homeController.userModel.schoolId!,
                            currentLearningYear:
                                homeController.currentLearningYear,
                            couresType: course.courseType!,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CompletionBadgeShimmer();
                            } else if (snapshot.hasError) {
                              return const CompletionBadge(completion: 0);
                            } else if (!snapshot.hasData) {
                              return const CompletionBadge(completion: 0);
                            } else {
                              return CompletionBadge(
                                completion: snapshot.data!.toDouble(),
                              );
                            }
                          },
                        ),
                        course.assignmentActive != null
                            ? Switch(
                                padding: EdgeInsets.zero,
                                value: course.assignmentActive == 1
                                    ? true
                                    : false,
                                activeColor: Colors.green,
                                onChanged: (value) {
                                  CoursesHelper.makeCourseInActive(
                                    course.scaid,
                                    value,
                                  );
                                },
                              )
                            : SizedBox(),
                      ],
                    ),
            ],
          ),
          FutureBuilder<Map<String, int>>(
            future: course.getCourseLp(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: LpShimmerLoader(),
                );
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const SizedBox.shrink();
              }
              final courseLp = snapshot.data!['total']!.toDouble();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${courseLp.toInt()}%',
                            style: TextStyle(
                              color: Color.lerp(
                                Colors.red,
                                Colors.green,
                                (courseLp / 100).clamp(0.0, 1.0),
                              )!,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: ' this LP: ',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          value: courseLp / 100,
                          minHeight: 8,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.lerp(
                              Colors.red,
                              Colors.green,
                              (courseLp / 100).clamp(0.0, 1.0),
                            )!,
                          ),
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          course.grade != null
              ? Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : SizedBox(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child:
                course.proficiency != null && course.proficiency!.totalCount > 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${course.proficiency!.totalCount} Learning Journeys',
                        style: TextStyle(color: Colors.black54),
                      ),
                      course.grade! != 7 &&
                              (course.grade! >= 2.5 || course.grade! == 8) &&
                              course.incomplete == 0 &&
                              course.graduated == 1
                          ? CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 12,
                              child: Center(
                                child: Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : ProficiencyWidget(
                              proficiency: course.proficiency!,
                              size: 12,
                            ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class CompletionBadge extends StatelessWidget {
  final double completion;

  const CompletionBadge({super.key, required this.completion});

  @override
  Widget build(BuildContext context) {
    // Clamp value between 0–1 for interpolation
    double normalized = (completion / 100).clamp(0.0, 1.0);

    // Background: light red → light green
    Color backgroundColor = Color.lerp(
      const Color.fromARGB(255, 255, 200, 200), // light red
      const Color.fromARGB(255, 205, 250, 205), // light green
      normalized,
    )!;

    // Text: red → green
    Color textColor = Color.lerp(Colors.red, Colors.green, normalized)!;

    return Container(
      width: 55,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          '${completion.toInt()}%',
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class CompletionBadgeShimmer extends StatelessWidget {
  const CompletionBadgeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: 55,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Container(
            height: 14,
            width: 24,
            color: Colors.white, // fake text area
          ),
        ),
      ),
    );
  }
}

class LpShimmerLoader extends StatelessWidget {
  const LpShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          // Fake percentage text
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(width: 50, height: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          // Fake progress bar
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(height: 8, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
