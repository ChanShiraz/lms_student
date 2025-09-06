import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/learning_journey/controller/summative_assessment_controller.dart';
import 'package:lms_student/features/learning_journey/helpers/rubric_helper.dart';
import 'package:lms_student/features/learning_journey/models/lesson.dart';
import 'package:lms_student/features/learning_journey/view/formative/fa_input_page.dart';
import 'package:lms_student/features/learning_journey/view/formative/fa_link_page.dart';
import 'package:lms_student/features/learning_journey/view/formative/formative_assessment_page.dart';
import 'package:lms_student/features/learning_journey/view/prior_knowledge_page.dart';
import 'package:lms_student/features/learning_journey/view/quill_page.dart';
import 'package:lms_student/features/learning_journey/view/summative/sa_input_page.dart';
import 'package:lms_student/features/learning_journey/view/summative/sa_link_page.dart';
import 'package:lms_student/features/learning_journey/view/summative/widgets/competency_widget.dart';
import 'package:lms_student/features/learning_journey/view/summative/widgets/non_science_standard.dart';
import 'package:lms_student/features/learning_journey/view/summative/widgets/rubric_widget.dart';
import 'package:lms_student/features/learning_journey/view/summative/widgets/science_standard_widget.dart';

class SummativeAssessmentPage extends StatefulWidget {
  const SummativeAssessmentPage({super.key, required this.journey});
  final Journey journey;
  static final routeName = '/summativeassessmentpage';

  @override
  State<SummativeAssessmentPage> createState() =>
      _SummativeAssessmentPageState();
}

class _SummativeAssessmentPageState extends State<SummativeAssessmentPage>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(SummativeAssessmentController());
  late TabController _tabController;

  final List<Map<String, dynamic>> levels = [
    {'label': 'EMERGING', 'color': Colors.orange, 'dplvlid': 2},
    {'label': 'Capable', 'color': Colors.lightBlue, 'dplvlid': 3},
    {'label': 'BRIDGING', 'color': Colors.purple, 'dplvlid': 4},
    {'label': 'PROFICIENT', 'color': Colors.blue, 'dplvlid': 5},
    {'label': 'METACOGNITIVE', 'color': Colors.green, 'dplvlid': 6},
  ];
  @override
  void initState() {
    _tabController = TabController(length: levels.length, vsync: this);
    controller.fetchSubmittedSummative(widget.journey.dmodSumId);
    controller.fetchSummativeLesson(widget.journey.dmodSumId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.journey.title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text('Summative Assessment'),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Obx(
            () => controller.fetchingSummativeLesson.value
                ? Center(child: CircularProgressIndicator())
                : controller.summativeLesson.value != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Task ',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: controller.summativeLesson.value!.task,
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Divider(),
                      ),

                      ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(),
                        title: Text(
                          'Rubric Information',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        children: [
                          DefaultTabController(
                            length: levels.length,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CompetencyWidget(),
                                ScienceStandardWidget(),
                                NonScienceStandardWidget(),
                                Text(
                                  'Scaffolding Rubric : ',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${controller.summativeLesson.value!.proficientRubric}',
                                ),
                                TabBar(
                                  isScrollable: true,
                                  controller: _tabController,
                                  tabs: levels
                                      .map(
                                        (level) => Tab(
                                          child: Text(
                                            level['label'],
                                            style: TextStyle(
                                              color: level['color'],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onTap: (value) {
                                    controller.rubricController.getRubric(
                                      drlid: controller
                                          .summativeLesson
                                          .value!
                                          .drlid,
                                      dplvlid: value + 2,
                                    );
                                  },
                                ),
                                RubricWidget(),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      Text(
                        'Summative Resources:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      ResourcesWidget(title: 'Approved Instructional Material'),
                      ResourcesWidget(title: 'Summative Instruction Video'),
                      ResourcesWidget(title: 'Cell Summative'),
                      SizedBox(height: 30),
                      Obx(
                        () => controller.fetchingSubSummative.value
                            ? Center(child: CircularProgressIndicator())
                            : controller.submittedSummative.value != null
                            ? SubmittedWidget(
                                controller: controller,
                                journey: widget.journey,
                              )
                            : Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'I am ready to submit my summative assessment.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Material(
                                      borderRadius: BorderRadius.circular(10),
                                      elevation: 1,
                                      child: ListTile(
                                        onTap: () => Get.toNamed(
                                          SaLinkPage.routeName,
                                          arguments: widget.journey,
                                        ),
                                        leading: Icon(Icons.link),
                                        title: Text('Link'),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Material(
                                      borderRadius: BorderRadius.circular(10),
                                      elevation: 1,
                                      child: ListTile(
                                        onTap: () => Get.toNamed(
                                          SaInputPage.routeName,
                                          arguments: widget.journey,
                                        ),
                                        leading: Icon(Icons.edit_outlined),
                                        title: Text('Direct Input'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  )
                : Center(child: Text('Some Error Occured!')),
          ),
        ),
      ),
    );
  }
}

class SubmittedWidget extends StatelessWidget {
  const SubmittedWidget({
    super.key,
    required this.controller,
    required this.journey,
  });
  final SummativeAssessmentController controller;
  final Journey journey;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM/dd/yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summative Assessment Info',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        // Submitted date
        Row(
          children: [
            Text(
              'Submitted:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            Text(
              dateFormat.format(controller.submittedSummative.value!.date),
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              'Assessed:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            Text(
              controller.submittedSummative.value!.assessed != null
                  ? dateFormat.format(
                      controller.submittedSummative.value!.assessed!,
                    )
                  : 'N/A',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ],
        ),
        const SizedBox(height: 6),

        Row(
          children: [
            Text(
              'Assessment:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            assessmentWidget(controller.submittedSummative.value!.status),
          ],
        ),
        const SizedBox(height: 12),

        // View link
        Row(
          children: [
            Text(
              'View My Summative:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                if (controller.submittedSummative.value!.type == 2 &&
                    controller.submittedSummative.value!.pathLink.isNotEmpty) {
                  launchMyUrl(controller.submittedSummative.value!.pathLink);
                } else if (controller.submittedSummative.value!.type == 4) {
                  Get.toNamed(
                    QuillPage.routeName,
                    arguments: [
                      controller.submittedSummative.value!.text!,
                      journey.title,
                    ],
                  );
                }
              },
              icon: Icon(Icons.open_in_new, size: 18, color: Colors.blue),
            ),
          ],
        ),
        controller.submittedSummative.value!.status == 2 ||
                controller.submittedSummative.value!.status == 1
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Feedback By ${controller.submittedSummative.value!.assessBy}',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
              )
            : SizedBox(),
        controller.submittedSummative.value!.status == 2 &&
                controller.submittedSummative.value!.comment != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  elevation: 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                      child: Text(
                        controller.submittedSummative.value!.comment!,
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
        controller.submittedSummative.value!.status == 2
            ? Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 1,
                    child: ListTile(
                      tileColor: Colors.orange.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                      onTap: () =>
                          Get.toNamed(SaLinkPage.routeName, arguments: journey),
                      leading: Icon(Icons.link),
                      title: Text('Link'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 1,
                    child: ListTile(
                      tileColor: Colors.orange.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                      onTap: () => Get.toNamed(
                        SaInputPage.routeName,
                        arguments: journey,
                      ),
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Direct Input'),
                    ),
                  ),
                ],
              )
            : SizedBox(),
      ],
    );
  }
}

class ResourcesWidget extends StatelessWidget {
  const ResourcesWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: CircleAvatar(radius: 2, backgroundColor: Colors.black),
        ),
        Text(title, style: TextStyle(color: Colors.blue)),
      ],
    );
  }
}
