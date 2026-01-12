import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:lms_student/common/custom_appbar.dart';
import 'package:lms_student/features/learning_journey/controller/lesson_materiel_controller.dart';
import 'package:lms_student/features/learning_journey/models/lesson.dart';
import 'package:lms_student/features/summative_assessment/models/lesson_tool.dart';
import 'package:lms_student/features/learning_journey/view/prior_knowledge_page.dart';
import 'package:lms_student/features/learning_journey/widgets/prior_knowledge_widget.dart';
import 'package:lms_student/features/summative_assessment/widgets/text_dialog.dart';
import 'package:shimmer/shimmer.dart';

class LessonMaterielPage extends StatefulWidget {
  const LessonMaterielPage({super.key, required this.lesson});
  static final routeName = '/lessonmaterielpage';
  final Lesson lesson;

  @override
  State<LessonMaterielPage> createState() => _LessonMaterielPageState();
}

class _LessonMaterielPageState extends State<LessonMaterielPage> {
  final controller = Get.put(LessonMaterielController());
  @override
  void initState() {
    controller.fetchLessonTools(widget.lesson.dmod_lesson_id);
    controller.fetchLessonMateriel(widget.lesson.dmod_lesson_id);
    controller.fetchLessondMateriel(widget.lesson.dmod_lesson_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Lesson Material',
        subtitle: widget.lesson.title,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          if (controller.loadingLessonTools.value ||
              controller.loadingLessonMaterial.value ||
              controller.loadingLessonddMaterial.value) {
            return loadingWidget(itemCount: 6);
          }

          return ListView(
            children: [
              ...controller.lessonTools.map(
                (lessonTool) => PriorKnowledgeWidget(
                  title: lessonTool.title,
                  description: lessonTool.description,
                  exist: lessonTool.exist,
                  type: lessonTool.type,
                  onClick: () {
                    controller.writeLessonToolAccessed(
                      widget.lesson.dmod_lesson_id,
                      lessonTool.dmodToolId,
                    );
                    if (lessonTool.path?.isNotEmpty ?? false) {
                      launchMyUrl(lessonTool.path!);
                    }
                    if (lessonTool.link?.isNotEmpty ?? false) {
                      launchMyUrl(lessonTool.link!);
                    }
                    if (lessonTool.type == 4) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            TextDialog(initialText: lessonTool.text),
                      );
                    }
                  },
                ),
              ),

              // LESSON MATERIALS
              ...controller.lessonMaterials.map(
                (lessonMaterial) => PriorKnowledgeWidget(
                  title: lessonMaterial.title,
                  description: lessonMaterial.description,
                  exist: lessonMaterial.exist,
                  type: lessonMaterial.type,
                  onClick: () {
                    controller.writeLessonMaterialAccessed(
                      widget.lesson.dmod_lesson_id,
                      lessonMaterial.dmodMatId,
                    );
                    if (lessonMaterial.link?.isNotEmpty ?? false) {
                      launchMyUrl(lessonMaterial.link!);
                    }
                    if (lessonMaterial.type == 4) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            TextDialog(initialText: lessonMaterial.text),
                      );
                    }
                  },
                ),
              ),

              // LESSON D MATERIALS
              ...controller.lessonddMaterials.map(
                (lessondMaterial) => PriorKnowledgeWidget(
                  showStatus: false,
                  title: lessondMaterial.title,
                  description: lessondMaterial.description,
                  exist: lessondMaterial.exist,
                  type: lessondMaterial.type,
                  onClick: () {
                    if (lessondMaterial.link?.isNotEmpty ?? false) {
                      launchMyUrl(lessondMaterial.link!);
                    }
                    if (lessondMaterial.type == 4) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            TextDialog(initialText: lessondMaterial.text),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

Widget loadingWidget({int itemCount = 2}) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: itemCount,
    itemBuilder: (context, index) => ShimmerWidget(),
  );
}

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
