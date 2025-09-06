import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:lms_student/features/profile/controller/edit_profile_controller.dart';
import 'package:lms_student/features/profile/model/user.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({super.key, required this.user});
  static final routeName = '/editprofilepage';
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                controller: controller.address1Controller,
                decoration: InputDecoration(label: Text('Address 1')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                controller: controller.address2Controller,
                decoration: InputDecoration(label: Text('Address 2')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                controller: controller.cityController,
                decoration: InputDecoration(label: Text('City')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                controller: controller.stateController,
                decoration: InputDecoration(label: Text('State')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                controller: controller.stateController,
                decoration: InputDecoration(label: Text('Password')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                controller: controller.aboutController,
                decoration: InputDecoration(label: Text('About')),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
