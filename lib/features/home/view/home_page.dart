import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms_student/common/round_container.dart';
import 'package:lms_student/common/topbar.dart';
import 'package:lms_student/features/auth/view/login_page.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/home/home.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/home/models/learning_journey.dart';
import 'package:lms_student/features/home/widgets/calender_widget.dart';
import 'package:lms_student/features/home/widgets/course_shimmer.dart';
import 'package:lms_student/features/home/widgets/course_widget.dart';
import 'package:lms_student/features/home/widgets/journey_widget.dart';
import 'package:lms_student/features/learning_journey/view/journey_page.dart';
import 'package:lms_student/features/summatives/view/all_journeyes_page.dart';
import 'package:lms_student/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static final routeName = '/homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController controller = Get.put(HomeController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: TopBar(title: 'DPNG', centerTitle: true, showBack: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: RefreshIndicator(
          onRefresh: () async {
            controller.fetchJournies();
            controller.fetchStudentCourses();
            //return controller.fetchJournies();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                RoundContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'Current Learning Period Work',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Obx(
                        () => controller.fetchingCourses.value
                            ? SizedBox()
                            : FutureBuilder<double>(
                                future: controller.calculateLp(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox();
                                  }
                                  if (snapshot.hasError) {
                                    return SizedBox();
                                  }
                                  double finalLp = snapshot.data ?? 0;
                                  double progressValue = (finalLp / 100).clamp(
                                    0.0,
                                    1.0,
                                  );

                                  Color progressColor;
                                  if (finalLp <= 25) {
                                    progressColor = const Color(0xFFDC2626);
                                  } else if (finalLp <= 50) {
                                    progressColor = const Color(0xFFF59E0B);
                                  } else if (finalLp <= 75) {
                                    progressColor = const Color(0xFF60A5FA);
                                  } else if (finalLp <= 89) {
                                    progressColor = const Color(0xFF2563EB);
                                  } else {
                                    progressColor = const Color(0xFF16A34A);
                                  }

                                  return Row(
                                    children: [
                                      Expanded(
                                        child: LinearProgressIndicator(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          minHeight: 18,
                                          value: progressValue,
                                          color: progressColor,
                                          backgroundColor: Colors.grey[300],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${finalLp.toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                      ),

                      SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        color: AppColors.primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                          child: Text(
                            'Calendar Week',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Obx(
                        () => CustomWeekCalendar(
                          homeController: controller,
                          currentDayColor: controller.fetchingJournies.value
                              ? Colors.grey
                              : overallIconColor(controller.journies),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                RoundContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'LEARNING JOURNEYS',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Obx(() {
                                  debugPrint(
                                    'controller loading ${controller.fetchingJournies.value}',
                                  );

                                  return controller.fetchingJournies.value
                                      ? SizedBox()
                                      : IconButton(
                                          onPressed: () {
                                            final selected = selectJourney(
                                              controller.journies,
                                            );
                                            if (selected != null) {
                                              Get.to(
                                                () => JourneyPage(
                                                  journey: selected,
                                                ),
                                              );
                                            } else {
                                              Get.toNamed(
                                                AllJourneyesPage.routeName,
                                                arguments: controller.journies,
                                              );
                                            }
                                          },
                                          icon: Icon(
                                            Icons.assistant_navigation,
                                            color: overallIconColor(
                                              controller.journies,
                                            ),
                                          ),
                                        );
                                }),
                              ],
                            ),
                          ),
                          Obx(
                            () =>
                                controller.fetchingJournies.value ||
                                    controller.fetchingJourniesError.isNotEmpty
                                ? SizedBox()
                                : TextButton(
                                    onPressed: () {
                                      Get.toNamed(
                                        AllJourneyesPage.routeName,
                                        arguments: controller.journies,
                                      );
                                    },
                                    child: Text('View All'),
                                  ),
                          ),
                        ],
                      ),
                      Obx(() {
                        if (controller.fetchingJournies.value) {
                          return SizedBox(
                            height: 100,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 5,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) =>
                                  JourneyWidgetShimmer(),
                            ),
                          );
                        }
                        if (controller.fetchingJourniesError.isNotEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      controller.fetchJournies();
                                    },
                                    icon: Icon(Icons.refresh_outlined),
                                  ),
                                  Text(
                                    'Something went wrong! please try again',
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          height: 100,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.journies.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => JourneyWidget(
                              journey: controller.journies[index],
                              onTap: () => Get.toNamed(
                                JourneyPage.routeName,
                                arguments: controller.journies[index],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                RoundContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COURSES',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double desiredTileWidth = 200;
                          int crossAxisCount =
                              (constraints.maxWidth / desiredTileWidth).floor();
                          if (crossAxisCount < 2) crossAxisCount = 2;

                          return Obx(() {
                            if (controller.fetchingCourses.value) {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 4,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 1,
                                    ),
                                itemBuilder: (context, index) =>
                                    const CourseShimmer(),
                              );
                            }
                            if (controller
                                .fetchingCoursesError
                                .value
                                .isNotEmpty) {
                              return Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        controller.fetchStudentCourses();
                                      },
                                      icon: Icon(Icons.refresh_outlined),
                                    ),
                                    Text(
                                      'Something went wrong! please try again',
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              );
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.courses.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 1,
                                  ),
                              itemBuilder: (context, index) => CourseWidget(
                                course: controller.courses[index],
                              ),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color overallIconColor(List<Journey> journies) {
    print('overall called');
    if (journies.any((j) => j.status == 3)) return Colors.red;
    if (journies.any((j) => j.status == 2)) return Colors.orange;
    if (journies.any((j) => j.status == null)) return Colors.blue;
    if (journies.any((j) => j.status == 1)) return Colors.green;
    if (journies.any((j) => j.status == 0)) return Colors.blue;
    return Colors.blue;
  }

  Journey? selectJourney(List<Journey> journies) {
    if (journies.any((j) => j.status == 3)) {
      final list = journies.where((j) => j.status == 3).toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return list.first;
    }
    if (journies.any((j) => j.status == 2)) {
      final list = journies.where((j) => j.status == 2).toList()
        ..sort((a, b) => b.dueDate.compareTo(a.dueDate));
      return list.first;
    }
    if (journies.any((j) => j.status == null)) {
      final list = journies.where((j) => j.status == null).toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return list.first;
    }
    if (journies.any((j) => j.status == 1)) {
      final list = journies.where((j) => j.status == 1).toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return list.first;
    }

    if (journies.any((j) => j.status == 0)) {
      final list = journies.where((j) => j.status == 0).toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return list.first;
    }
    return null;
  }
}

Widget buildLoadingShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 18,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(height: 18, width: 50, color: Colors.grey[300]),
      ],
    ),
  );
}
