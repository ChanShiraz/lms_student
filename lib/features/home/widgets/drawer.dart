import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms_student/features/auth/view/login_page.dart';
import 'package:lms_student/features/courses/view/courses_page.dart';
import 'package:lms_student/features/messages/view/messaging_page.dart';
import 'package:lms_student/features/profile/controller/profile_controller.dart';
import 'package:lms_student/features/profile/view/profile_page.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => UserAccountsDrawerHeader(
                accountName:
                    !profileController.isLoading.value &&
                        profileController.user != null
                    ? Text(
                        '${profileController.user!.first} ${profileController.user!.last}',
                      )
                    : null,
                accountEmail:
                    !profileController.isLoading.value &&
                        profileController.user != null
                    ? Text('${profileController.user!.roleDescription}')
                    : null,
              ),
            ),

            ListTile(
              leading: Icon(Icons.calendar_today_rounded, size: 20),
              title: Text(
                'Calendar',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            ),

            ListTile(
              onTap: () => Get.toNamed(MessagingPage.routeName),
              leading: Icon(Icons.message, size: 20),
              title: Text(
                'Messages',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            ),
            ListTile(
              leading: Icon(Icons.star, size: 20),
              title: Text(
                'Personal Success Plan',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            ),

            ListTile(
              leading: Icon(Icons.history_rounded, size: 20),
              title: Text(
                'Past Courses',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            ),
            ListTile(
              leading: Icon(Icons.video_library_rounded, size: 20),
              title: Text(
                'Tutorials',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, size: 20),
              title: Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
              onTap: () => Get.toNamed(ProfilePage.routeName),
            ),
            ListTile(
              leading: Icon(Icons.logout, size: 20),
              title: Text(
                'Log out',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
              onTap: () {
                final box = GetStorage();
                box.write('auth', false);
                box.write('userid', null);
                box.write('user', null);
                Get.offAllNamed(LoginPage.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
