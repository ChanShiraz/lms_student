import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:lms_student/features/learning_journey/controller/knowledge_controller.dart';
import 'package:lms_student/features/learning_journey/models/lesson.dart';
import 'package:lms_student/features/learning_journey/models/prior_knowledge.dart';
import 'package:lms_student/features/learning_journey/view/lesson_materiel_page.dart';
import 'package:lms_student/features/learning_journey/widgets/prior_knowledge_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PriorKnowledgePage extends StatefulWidget {
  const PriorKnowledgePage({super.key, required this.lesson});
  static final routeName = '/priorknowledgepage';
  final Lesson lesson;

  @override
  State<PriorKnowledgePage> createState() => _PriorKnowledgePageState();
}

class _PriorKnowledgePageState extends State<PriorKnowledgePage> {
  final controller = Get.put(KnowledgeController());
  @override
  void initState() {
    controller.fetchPriorKnowledge(widget.lesson.lessonId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.lesson.title),
            Text('Prior Knowledge', style: TextStyle(fontSize: 16)),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assess your understanding before starting the lesson.',
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(height: 10),
            Obx(
              () => controller.loadingKnowledges.value
                  ? loadingWidget(itemCount: 3)
                  : Expanded(
                      child: ListView.builder(
                        itemCount: controller.priorKnowledges.length,
                        itemBuilder: (context, index) {
                          PriorKnowledge knowledge =
                              controller.priorKnowledges[index];
                          return PriorKnowledgeWidget(
                            title: knowledge.title,
                            description: knowledge.description,
                            exist: knowledge.exist,
                            type: knowledge.type,
                            onClick: () {
                              controller.writeAccessed(
                                widget.lesson.lessonId,
                                knowledge.dmod_pmat_id,
                              );
                              if (knowledge.link != null &&
                                  knowledge.link!.isNotEmpty) {
                                launchMyUrl(knowledge.link!);
                              }
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> launchMyUrl(String link) async {
  try {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url)) {
      // throw Exception('Could not launch $url');
    }
  } catch (e) {
    Get.rawSnackbar(message: 'Link can\'t launched!');
  }
}
