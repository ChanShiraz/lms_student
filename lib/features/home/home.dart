import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms_student/features/auth/view/login_page.dart';
import 'package:lms_student/features/courses/view/courses_page.dart';
import 'package:lms_student/features/grades/view/grades_page.dart';
import 'package:lms_student/features/home/view/home_page.dart';
import 'package:lms_student/features/home/widgets/drawer.dart';
import 'package:lms_student/features/messages/view/messaging_page.dart';
import 'package:lms_student/features/profile/controller/profile_controller.dart';
import 'package:lms_student/features/profile/view/profile_page.dart';
import 'package:lms_student/features/transript/view/transcript_page.dart';
import 'package:lms_student/utils/app_colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static final routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  List<Widget> pages = [
    HomePage(),
    CoursesPage(),
    GradesPage(),
    MessagingPage(),
  ];
  @override
  void initState() {
    ProfileController profileController = Get.put(ProfileController());
    profileController.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined),
          ),
          IconButton(
            onPressed: () {
              Get.to(ProfilePage());
            },
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: IndexedStack(index: selectedIndex, children: pages),
      // pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },

        selectedIconTheme: const IconThemeData(size: 30),
        backgroundColor: AppColors.primaryColor,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety_outlined),
            label: 'Grades',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Messages'),
        ],
      ),
    );
  }
}
