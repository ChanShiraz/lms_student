import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms_student/features/auth/view/login_page.dart';
import 'package:lms_student/features/profile/model/user.dart';
import 'package:lms_student/features/home/home.dart';
import 'package:lms_student/utils/app_theme.dart';
import 'package:lms_student/utils/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ctetnzfxiuqpxaufhmio.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN0ZXRuemZ4aXVxcHhhdWZobWlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQzNzQyODcsImV4cCI6MjA0OTk1MDI4N30.i2r1g2raeaC0cmQuZGqjGG5WtrfAJ8_rQVzD5HnWbTg',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    bool? login = box.read('auth');
    final userData = box.read('user');
    UserModel? userModel = userData != null
        ? UserModel.fromJson(userData)
        : null;
    return GetMaterialApp(
      title: 'DPNG',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      //home: SummativeAssessedPage(),
      initialRoute:
          //NotificationsPage.routeName,
          (login == null || !login || userModel == null)
          ? LoginPage.routeName
          : Home.routeName,
      getPages: routes,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
    );
  }
}
