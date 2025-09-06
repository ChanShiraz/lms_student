import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/home/models/course.dart';
import 'package:lms_student/features/home/services/grades_helper.dart';
import 'package:lms_student/features/home/models/proficiency.dart';
import 'package:lms_student/features/summatives/view/summative_page.dart';

class CourseWidget extends StatefulWidget {
  CourseWidget({super.key, required this.course});
  final Course course;
  final controller = Get.find<HomeController>();

  @override
  State<CourseWidget> createState() => _CourseWidgetState();
}

class _CourseWidgetState extends State<CourseWidget> {
  @override
  void initState() {
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
    return InkWell(
      onTap: () =>
          Get.toNamed(SummativePage.routeName, arguments: widget.course),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            widget.course.img != null
                ? CachedNetworkImage(
                    height: 85,
                    width: 85,
                    imageUrl: widget.course.img!,
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.broken_image),
                  )
                : Image.asset('assets/images/journey.jpeg', height: 85),
            widget.course.title != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      widget.course.title!,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  )
                : SizedBox(),
            widget.course.grade != null
                ? Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 3),
            widget.course.proficiency != null
                ? ProficiencyWidget(
                    proficiency: widget.course.proficiency!,
                    size: 10,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class ProficiencyWidget extends StatelessWidget {
  const ProficiencyWidget({
    super.key,
    required this.proficiency,
    this.size = 7,
  });
  final Proficiency proficiency;
  final int size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BubbleWidget(
          count: proficiency.notCompleted,
          color: Colors.blue,
          size: size,
        ),
        BubbleWidget(
          count: proficiency.completed,
          color: Colors.green,
          size: size,
        ),
        BubbleWidget(
          count: proficiency.resubmit,
          color: Colors.orange,
          size: size,
        ),
        BubbleWidget(count: proficiency.pastDue, color: Colors.red, size: size),
      ],
    );
  }
}

class BubbleWidget extends StatelessWidget {
  const BubbleWidget({
    super.key,
    required this.count,
    required this.color,
    required this.size,
  });
  final int count;
  final Color color;
  final int size;
  @override
  Widget build(BuildContext context) {
    return count > 0
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: CircleAvatar(
              radius: size.toDouble(),
              backgroundColor: color,
              child: Center(
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: size.toDouble(),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        : SizedBox();
  }
}
