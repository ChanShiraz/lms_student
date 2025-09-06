import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms_student/features/profile/model/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileController extends GetxController {
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final aboutController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  final box = GetStorage();
  RxBool isLoading = false.obs;
  UserModel? user;
}
