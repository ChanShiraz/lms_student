import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:lms_student/features/home/home.dart';
import 'package:lms_student/features/profile/model/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  SupabaseClient supabase = Supabase.instance.client;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final box = GetStorage();

  RxBool isLoading = false.obs;

  Future<void> login() async {
    isLoading.value = true;
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('email', emailController.text.trim())
          .maybeSingle();

      if (response == null) {
        Get.snackbar(
          'Login Failed',
          'User not found',
          titleText: Text('Login Failed'),
        );
        return;
      }

      final dbPassword = response['password'];
      final isActive = response['active'] == 1;

      if (dbPassword != passwordController.text) {
        Get.snackbar(
          'Login Failed',
          'Invalid email or password',
          titleText: Text('Login Failed'),
        );
        return;
      }
      if (!isActive) {
        Get.snackbar(
          'Login Failed',
          'Your account is inactive',
          titleText: Text('Login Failed'),
        );
        return;
      }

      final userId = response['userid'];
      await box.write('auth', true);
      await box.write('userid', userId);
      await getUser();
      Get.offAllNamed(Home.routeName);
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong!');
      print('error login $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUser() async {
    isLoading.value = true;

    try {
      final userId = await box.read('userid');
      print('userid ${await box.read('userid')}');
      if (userId != null) {
        final response = await supabase
            .from('users')
            .select('*, roles:roles!users_role_fkey(description)')
            .eq('userid', userId)
            .eq('active', 1)
            .maybeSingle();
         print('response $response');    
        if (response != null) {
          UserModel user = UserModel.fromJson(response);
          await box.write('user', user.toJson());
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
