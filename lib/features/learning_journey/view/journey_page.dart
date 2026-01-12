import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:lms_student/common/custom_appbar.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/learning_journey/controller/journey_controller.dart';
import 'package:lms_student/features/learning_journey/widgets/lesson_widget.dart';
import 'package:lms_student/features/learning_journey/widgets/modified_stepper.dart';
import 'package:lms_student/features/summative_assessment/view/summative_assessment_page.dart'
    show SummativeAssessmentPage;
import 'package:lms_student/features/summatives/widgets/summative_widget.dart';

class JourneyPage extends StatefulWidget {
  const JourneyPage({super.key, required this.journey});
  static final routeName = '/journeypage';
  final Journey journey;

  @override
  State<JourneyPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage> {
  final int _currentStep = 0;
  final controller = Get.put(JourneyController());
  @override
  void initState() {
    controller.getTitles(widget.journey.dmodSumId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color color = widget.journey.status != null
        ? dateColor(widget.journey.status!)
        : Colors.blue;
    return Scaffold(
      appBar:
          // AppBar(title: Text('Learning Journey')),
          CustomAppbar(title: 'Learning Journey'),
      body: Obx(
        () => controller.isLoadingTitles.value
            ? Center(child: CircularProgressIndicator())
            : Stepper2(
                onStepTapped: (value) {
                  if (value == controller.lessons.length + 1) {
                    Get.toNamed(
                      SummativeAssessmentPage.routeName,
                      arguments: widget.journey,
                    );
                  }
                },
                currentStep: _currentStep,
                controlsBuilder: (context, details) => const SizedBox.shrink(),
                stepIconBuilder: (stepIndex, stepState) =>
                    CircleAvatar(radius: 5),
                steps: [
                  titleWidget(),
                  if (controller.lessons.isNotEmpty)
                    ...controller.lessons.map(
                      (element) => Step2(
                        title: LessonWidget(
                          lesson: element,
                          journey: widget.journey,
                        ),
                        connectorSize: 4,
                        isActive: true,
                        state: StepState.disabled,
                      ),
                    ),

                  bottomWidget(color),
                ],
              ),
      ),
    );
  }

  Step2 titleWidget() {
    return Step2(
      connectorSize: 1,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            widget.journey.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),

      isActive: true,
    );
  }

  Step2 bottomWidget(Color color) {
    return Step2(
      connectorSize: 1,
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    color == Colors.orange || color == Colors.red
                        ? Icons.warning
                        : Icons.star,
                    color: color,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Summative ${widget.journey.title}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              widget.journey.status == null ||
                      (widget.journey.status != null &&
                          widget.journey.status == 3)
                  ? Row(
                      children: [
                        Text(
                          'Due Date : ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          DateFormat(
                            'MM/dd/yyyy',
                          ).format(widget.journey.dueDate),
                        ),
                      ],
                    )
                  : SizedBox(),
              widget.journey.assessedDate != null
                  ? Row(
                      children: [
                        Text(
                          'Assessed Date : ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          DateFormat(
                            'MM/dd/yyyy',
                          ).format(widget.journey.assessedDate!),
                        ),
                      ],
                    )
                  : SizedBox(),
              widget.journey.assessedBy != null
                  ? Row(
                      children: [
                        Text(
                          'Assessed by : ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(widget.journey.assessedBy!),
                      ],
                    )
                  : SizedBox(),
              widget.journey.grade != null
                  ? Row(
                      children: [
                        Text(
                          'Grade : ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        buildGradeWidget(widget.journey.grade!),
                      ],
                    )
                  : SizedBox(),
              SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        status(widget.journey.status),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      isActive: true,
    );
  }

  Color dateColor(int status) {
    switch (status) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.red;
    }
  }

  String status(int? status) {
    if (status == null) {
      return 'ASSIGNED';
    }
    if (status == 0) {
      return 'ASSIGNED';
    }
    if (status == 1) {
      return 'COMPLETED';
    }
    if (status == 2) {
      return 'RESUBMIT';
    }
    if (status == 3) {
      return 'PAST DUE';
    }
    return '';
  }
}
