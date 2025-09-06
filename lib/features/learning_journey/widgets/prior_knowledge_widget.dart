import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lms_student/features/learning_journey/controller/knowledge_controller.dart';
import 'package:lms_student/features/learning_journey/models/prior_knowledge.dart';

class PriorKnowledgeWidget extends StatelessWidget {
  const PriorKnowledgeWidget({
    super.key,

    required this.title,
    required this.description,
    required this.exist,
    required this.type,
    required this.onClick,
    this.showStatus = true,
  });
  //final PriorKnowledge priorKnowledge;
  //final KnowledgeController controller;
  final String title;
  final String description;
  final bool exist;
  final bool showStatus;

  final int type;
  final VoidCallback onClick;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        elevation: 0.3,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: ExpansionTile(
          childrenPadding: EdgeInsets.all(10),
          leading: type == 2
              ? Icon(Icons.link, color: Colors.blue)
              : Icon(Icons.chrome_reader_mode),
          title: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),

          subtitle: showStatus
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Status: '),
                      TextSpan(
                        text: exist ? 'Viewed' : 'Not Viewed',
                        style: TextStyle(
                          color: exist ? Colors.green : Colors.blue,
                        ),
                      ),
                    ],
                  ),
                )
              : null,

          shape: const Border(),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(description),
            ),
            typeWidget(),
          ],
        ),
      ),
    );
  }

  Widget typeWidget() {
    if (type == 1 || type == 3) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.warning, color: Colors.red),
          SizedBox(width: 5),
          Text('“No longer available” (legacy type; unsupported)'),
        ],
      );
    } else if (type == 2) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: ElevatedButton(
          onPressed: onClick,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 40),
          ),
          child: Icon(Icons.link),
        ),
      );
    } else if (type == 4) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: ElevatedButton(
          onPressed: onClick,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 40),
          ),
          child: Icon(Icons.chrome_reader_mode_sharp),
        ),
      );
    }
    return SizedBox();
  }
}

// class PriorKnowledgeWidget extends StatelessWidget {
//   const PriorKnowledgeWidget({
//     super.key,
//     required this.priorKnowledge,
//     required this.controller,
//     required this.lessonId,
//   });
//   final PriorKnowledge priorKnowledge;
//   final int lessonId;
//   final KnowledgeController controller;
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       elevation: 0.5,
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(10),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: ExpansionTile(
//           title: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               priorKnowledge.type == 2
//                   ? Icon(Icons.link, color: Colors.blue)
//                   : Icon(Icons.chrome_reader_mode),
//               SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(width: 15),
//                     Text(
//                       priorKnowledge.title,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Text.rich(
//                       TextSpan(
//                         children: [
//                           TextSpan(text: 'Status: '),
//                           TextSpan(
//                             text: priorKnowledge.exist
//                                 ? 'Viewed'
//                                 : 'Not Viewed',
//                             style: TextStyle(
//                               color: priorKnowledge.exist
//                                   ? Colors.green
//                                   : Colors.blue,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           shape: const Border(),
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 10),
//               child: Text(priorKnowledge.description),
//             ),
//             typeWidget(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget typeWidget() {
//     if (priorKnowledge.type == 1 || priorKnowledge.type == 3) {
//       return Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Icon(Icons.warning, color: Colors.red),
//           SizedBox(width: 5),
//           Text('No longer available” (legacy type; unsupported)'),
//         ],
//       );
//     } else if (priorKnowledge.type == 2) {
//       return ElevatedButton(
//         onPressed: () {
//           controller.writeAccessed(lessonId, priorKnowledge.dmod_pmat_id);
//         },
//         style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 40)),
//         child: Icon(Icons.link),
//       );
//     } else if (priorKnowledge.type == 4) {
//       return ElevatedButton(
//         onPressed: () {},
//         style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 40)),
//         child: Icon(Icons.chrome_reader_mode_sharp),
//       );
//     }
//     return SizedBox();
//   }
// }
