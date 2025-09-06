import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms_student/features/profile/model/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final box = GetStorage();
  RxBool isLoading = false.obs;
  UserModel? user;

  void getUser() async {
    isLoading.value = true;
    try {
      final userId = await box.read('userid');
      if (userId != null) {
        final response = await supabase
            .from('users')
            .select('*, roles:roles!users_role_fkey(description)')
            .eq('userid', userId)
            .maybeSingle();
        if (response != null) {
          user = UserModel.fromJson(response);
          //await box.write('user', user);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        'Some error occured!',
        titleText: Text('Error'),
      );
      print('error gettting user $e');
    }
    isLoading.value = false;
  }
}
