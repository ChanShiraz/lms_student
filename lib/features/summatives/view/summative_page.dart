import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:lms_student/features/courses/model/learning_journey.dart';
import 'package:lms_student/features/home/services/grades_helper.dart';
import 'package:lms_student/features/summatives/widgets/summative_widget.dart';
import 'package:lms_student/features/home/models/course.dart';
import 'package:lms_student/features/summatives/controller/summative_controller.dart';

class SummativePage extends StatefulWidget {
  const SummativePage({super.key, required this.course});
  final Course course;
  static final routeName = '/SummativePage';

  @override
  State<SummativePage> createState() => _SummativePageState();
}

class _SummativePageState extends State<SummativePage> {
  late SummativeController controller;
  @override
  void initState() {
    controller = Get.put(SummativeController(course: widget.course));
    controller.fetchSummatives();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final label = GradeHelper.getGradeLabel(
      // widget.course.title!,
      widget.course.grade ?? 0.0,
      widget.course.graduated ?? 0,
      widget.course.incomplete ?? 1,
    );
    final color = GradeHelper.getGradeColor(label);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title ?? ''),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learing Journeys',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    Text('Current Grade : '),
                    widget.course.grade != null
                        ? Text(
                            label,
                            style: TextStyle(
                              //fontSize: 10,
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ],
            ),
          ),
          Obx(
            () => controller.isLoadingSummative.value
                ? Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) => SummativeShimmerWidget(),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: controller.summatives.length,
                      itemBuilder: (context, index) => SummativeWidget(
                        summative: controller.summatives[index],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
