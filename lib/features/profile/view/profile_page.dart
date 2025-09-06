import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:lms_student/features/profile/controller/profile_controller.dart';
import 'package:lms_student/features/profile/model/user.dart';
import 'package:lms_student/features/profile/view/edit_profile_page.dart';
import 'package:lms_student/features/profile/widgets/detail_widget.dart';
import 'package:lms_student/utils/app_colors.dart';
//import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});
  static final routeName = '/profilepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Obx(() {
        return controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              )
            : controller.user != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.user!.avatar != null &&
                            controller.user!.avatar!.isNotEmpty
                        ? Center(
                            child: CircleAvatar(
                              radius: 80,
                              child: Image.network(
                                controller.user!.avatar!,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 20),
                    DetailWidget(
                      title: 'First name: ',
                      text: controller.user!.first,
                    ),
                    DetailWidget(
                      title: 'Last name : ',
                      text: controller.user!.last,
                    ),
                    DetailWidget(
                      title: 'Address 1 : ',
                      text: controller.user!.address1,
                    ),
                    DetailWidget(
                      title: 'Address 2 : ',
                      text: controller.user!.address2,
                    ),
                    DetailWidget(title: 'City : ', text: controller.user!.city),
                    DetailWidget(
                      title: 'Phone : ',
                      text: controller.user!.phone,
                    ),
                    DetailWidget(
                      title: 'Password : ',
                      text: controller.user!.password,
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(
                            EditProfilePage.routeName,
                            arguments: controller.user,
                          );
                        },
                        child: Text('Edit Profile'),
                      ),
                    ),
                  ],
                ),
              )
            : Icon(Icons.error);
      }),
    );
  }
}
