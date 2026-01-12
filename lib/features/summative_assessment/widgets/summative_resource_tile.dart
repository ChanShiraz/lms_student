import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms_student/common/round_container.dart';
import 'package:lms_student/common/shimmer_tile.dart';
import 'package:lms_student/features/summative_assessment/models/approved_material.dart';
import 'package:lms_student/features/summative_assessment/models/resource.dart';
import 'package:lms_student/features/learning_journey/view/prior_knowledge_page.dart';
import 'package:lms_student/features/summative_assessment/widgets/text_dialog.dart';
import 'package:lms_student/features/summative_assessment/controller/summative_assessment_controller.dart';

class SummativeResourceTile extends StatelessWidget {
  SummativeResourceTile({super.key});
  final controller = Get.find<SummativeAssessmentController>();

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
            child: Icon(
              Icons.text_snippet_outlined,
              size: 20,
              color: Colors.black,
            ),
          ),
          shape: Border(),
          title: Text(
            'Summative resources',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            'Text, links, and approved material',
            style: TextStyle(color: Colors.grey),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => !controller.fetchingResources.value
                    ? TagChip(
                        color: Colors.grey.shade50,
                        child: Text(
                          '${controller.approveMat.length + controller.resources.length} items',
                        ),
                      )
                    : SizedBox(),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.expand_more),
            ],
          ),

          children: [
            // Obx(
            //   () => controller.fetchingResources.value
            //       ? List.generate(
            //           2,
            //           (index) =>
            //               ShimmerTile(width: double.infinity, height: 90),
            //         )
            //       : ,
            // ),
            Obx(
              () => controller.fetchingResources.value
                  ? ShimmerTile(width: double.infinity, height: 90)
                  : ResourceList(),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ResourceList extends StatelessWidget {
  ResourceList({super.key});
  final controller = Get.find<SummativeAssessmentController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //  approve material
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.approveMat.length,
          itemBuilder: (context, index) {
            return MaterialWidget(material: controller.approveMat[index]);
          },
        ),
        SizedBox(height: 8),
        //resources
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.resources.length,
          itemBuilder: (context, index) {
            return ResourceWidget(resource: controller.resources[index]);
          },
        ),
      ],
    );
  }
}

class ResourceWidget extends StatelessWidget {
  const ResourceWidget({super.key, required this.resource});
  final Resource resource;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: RoundContainer(
        color: Colors.grey.shade50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                RoundContainer(
                  circular: 15,
                  color: Colors.white,
                  child: Icon(
                    resource.type == 2 ? Icons.link : Icons.menu_book_rounded,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      resource.description ?? '',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Reference resource',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                if (resource.type == 2) {
                  launchMyUrl(resource.value);
                } else if (resource.type == 4) {
                  showDialog(
                    context: context,
                    builder: (_) => TextDialog(initialText: resource.value),
                  );
                }
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                overlayColor: Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Open', style: TextStyle(color: Colors.black87)),
                  SizedBox(width: 5),
                  Icon(Icons.open_in_new_rounded, color: Colors.black87),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MaterialWidget extends StatelessWidget {
  const MaterialWidget({super.key, required this.material});
  final ApprovedMaterial material;

  @override
  Widget build(BuildContext context) {
    return RoundContainer(
      color: Colors.grey.shade50,
      child: Row(
        children: [
          Expanded(
            // 👈 THIS FIXES THE OVERFLOW
            child: Row(
              children: [
                RoundContainer(
                  circular: 15,
                  color: Colors.white,
                  child: const Icon(Icons.menu_book_rounded),
                ),
                const SizedBox(width: 10),
                Expanded(
                  // 👈 ALSO REQUIRED
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        material.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Approved instructional material',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => launchMyUrl(material.path),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              overlayColor: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Open', style: TextStyle(color: Colors.black87)),
                SizedBox(width: 5),
                Icon(Icons.open_in_new_rounded, color: Colors.black87),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
