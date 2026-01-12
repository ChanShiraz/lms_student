import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lms_student/common/round_container.dart';
import 'package:lms_student/common/shimmer_tile.dart';
import 'package:lms_student/features/learning_journey/helpers/rubric_helper.dart';
import 'package:lms_student/features/summative_assessment/widgets/competency_widget.dart';
import 'package:lms_student/features/summative_assessment/widgets/non_science_standard.dart';
import 'package:lms_student/features/summative_assessment/widgets/rubric_widget.dart';
import 'package:lms_student/features/summative_assessment/widgets/science_standard_widget.dart';
import 'package:lms_student/features/summative_assessment/controller/summative_assessment_controller.dart';

class RubricInformationTile extends StatelessWidget {
  const RubricInformationTile({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundContainer(
      padding: 0,
      circular: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,

          leading: RoundContainer(
            color: Colors.grey.shade50,
            circular: 15,
            child: Icon(Icons.done_rounded, size: 20),
          ),
          shape: Border(),
          title: Text(
            'Rubric information',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            'Competency, standard, and scaffold levels',
            style: TextStyle(color: Colors.grey),
          ),
          children: [
            SizedBox(height: 10),
            RoundContainer(
              color: Colors.grey.shade50,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Competency and standard',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 10),
                        CompetencyWidget(),
                        SizedBox(height: 10),
                        ScienceStandardWidget(),
                        NonScienceStandardWidget(),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.shade100),
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'View full\nrubric',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.ios_share_outlined,
                            color: Colors.black,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ScaffolingRubbric(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ScaffolingRubbric extends StatefulWidget {
  const ScaffolingRubbric({super.key});

  @override
  State<ScaffolingRubbric> createState() => _ScaffolingRubbricState();
}

class _ScaffolingRubbricState extends State<ScaffolingRubbric>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<SummativeAssessmentController>();
  late TabController _tabController;
  final List<Map<String, dynamic>> levels = [
    {
      'label': 'EMERGING',
      'color': Colors.orange,
      'dplvlid': 2,
      'des': 'beginning to identify plan and goals',
      'tag': 'Starting',
    },
    {
      'label': 'CAPABLE',
      'color': Colors.lightBlue,
      'dplvlid': 3,
      'des': 'identifies plan and goal with some support',
      'tag': 'Developing',
    },
    {
      'label': 'BRIDGING',
      'color': Colors.purple,
      'dplvlid': 4,
      'des': 'identifies plan and goal independently',
      'tag': 'Progressing',
    },
    {
      'label': 'PROFICIENT',
      'color': Colors.blue,
      'dplvlid': 5,
      'des': 'connects plan components to outcomes',
      'tag': 'Strong',
    },
    {
      'label': 'METACOGNITION',
      'color': Colors.green,
      'dplvlid': 6,
      'des': 'reflects and adjusts plan strategically',
      'tag': 'Reflective',
    },
  ];
  final RubricController rubricController = Get.put(RubricController());
  @override
  void initState() {
    _tabController = TabController(length: levels.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RoundContainer(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scaffolding rubric',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  Text(
                    'Select a level to preview its descriptor',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              RoundContainer(
                padding: 5,
                circular: 15,
                child: Row(
                  children: [
                    Icon(Icons.error_outline, size: 15),
                    SizedBox(width: 5),
                    Text('Preview', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          DefaultTabController(
            length: levels.length,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => TabBar(
                    indicatorColor:
                        levels[controller.selectedRubric.value]['color'],
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
                      controller.selectedRubric.value = value;
                      controller.rubricController.getRubric(
                        drlid: controller.summativeLesson.value!.drlid,
                        dplvlid: value + 2,
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                // RubricWidget(),
                Obx(() {
                  return rubricController.fetchingRubric.value
                      ? ShimmerTile(width: double.infinity, height: 100)
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: rubricController.rubrics.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Descriptor(
                              description: rubricController.rubrics[index],
                              title:
                                  levels[controller
                                      .selectedRubric
                                      .value]['label'],
                              desc:
                                  levels[controller
                                      .selectedRubric
                                      .value]['des'],
                              tag:
                                  levels[controller
                                      .selectedRubric
                                      .value]['tag'],
                            );
                          },
                        );
                }),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Descriptor extends StatelessWidget {
  const Descriptor({
    super.key,
    required this.title,
    required this.description,
    required this.desc,
    required this.tag,
  });
  final String title;
  final String desc;
  final String description;
  final String tag;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoundContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Descriptor',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '$title — $desc',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  TagChip(
                    color: Colors.grey.shade50,
                    child: Text(tag, style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              SizedBox(height: 5),
              RubricWidget(),
            ],
          ),
        ),
        SizedBox(height: 10),
        RoundContainer(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'What the student should be able to do',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
              Text(
                'Identify the academic, behavior, and personal plan and the goal.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
