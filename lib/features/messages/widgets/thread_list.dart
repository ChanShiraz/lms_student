import 'package:flutter/material.dart';
import 'package:lms_student/common/summatives_shimmer.dart';
import 'package:lms_student/features/messages/models/chat_course_model.dart';
import 'package:lms_student/features/messages/models/chat_thread.dart';
import 'package:lms_student/features/messages/models/thread_types.dart';
import 'package:lms_student/features/messages/widgets/search_field.dart';
import 'package:lms_student/features/messages/widgets/tag_chip.dart';

class ThreadsList extends StatelessWidget {
  // final ChatCourseModel course;
  final List<ChatThread> threads;
  final VoidCallback onBack;
  final ValueChanged<ChatThread> onSelect;
  final bool isLoading;
  final String? selectedId;

  const ThreadsList({
    super.key,
    // required this.course,
    required this.threads,
    required this.onBack,
    required this.onSelect,
    required this.isLoading,
    required this.selectedId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isLoading
            ? SummativesShimmer(
                padding: 0.5,
                borderRadius: 1,
                height: 40,
                quantity: 6,
              )
            : Expanded(
                child: ListView.separated(
                  itemCount: threads.length,
                  itemBuilder: (_, i) {
                    final p = threads[i];
                    return ListTile(
                      tileColor: Colors.grey.shade100,
                      selectedColor: Colors.black,
                      selectedTileColor: Colors.grey.shade200,
                      selected: selectedId != null && selectedId == p.thread_id,
                      //leading: CircleAvatar(child: Text(p.first[0])),
                      title: Text(
                        p.kind == ThreadType.direct
                            ? p.userName ?? ''
                            : p.title ?? '',
                        style: const TextStyle(fontSize: 15),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            p.kind == ThreadType.course && p.courseTitle != null
                                ? TagChip(
                                    p.courseTitle!,
                                    color: Colors.grey.shade300,
                                  )
                                : SizedBox(),
                            SizedBox(width: 5),
                            Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              p.last_message ?? '',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () => onSelect(p),
                      trailing: p.unreadCount > 0
                          ? CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 10,
                              child: Text(
                                p.unreadCount.toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : SizedBox(),
                    );
                  },
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, thickness: 0.3),
                ),
              ),
      ],
    );
  }
}
