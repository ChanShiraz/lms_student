import 'package:flutter/material.dart';
import 'package:flutter_quill/internal.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:lms_student/features/messages/controllers/new_chat_controller.dart';
import 'package:lms_student/features/messages/widgets/people_list.dart';

class NewChatDialog extends StatefulWidget {
  const NewChatDialog({super.key});

  @override
  State<NewChatDialog> createState() => _NewChatDialogState();
}

class _NewChatDialogState extends State<NewChatDialog> {
  final controller = Get.put(NewChatController());

  @override
  void initState() {
    controller.fetchPeoples();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: isMobile ? null : MediaQuery.of(context).size.width * 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Create New Chat', style: TextStyle(fontSize: 18)),
              trailing: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.cancel_outlined),
              ),
            ),
            Divider(),
            Obx(
              () => PeopleList(
                peoples: controller.peoples,
                onSelect: (value) async {
                  await controller.createDirectChatThread(
                    otherUserId: value.userId,
                  );
                  Navigator.of(context).pop();
                },
                isLoading: controller.fetchingPeople.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
