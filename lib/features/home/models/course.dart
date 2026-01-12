// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/home/models/proficiency.dart';
import 'package:lms_student/features/home/services/grades_helper.dart';
import 'package:lms_student/services/courses_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Course {
  final int cid;
  int scaid;
  final String? img;
  final String? title;
  final double? simpleGrade;
  final double? grade;
  final int? graduated;
  final int? incomplete;
  final Proficiency? proficiency;
  final int? courseType;
  final String? teacher;
  final int? active;
  int? assignmentActive;
  Course({
    required this.cid,
    required this.scaid,
    this.img,
    this.title,
    this.grade,
    this.simpleGrade,
    this.graduated,
    this.incomplete,
    this.proficiency,
    this.courseType,
    this.teacher,
    this.active,
    this.assignmentActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'img': img, 'title': title};
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      cid: map['a_cid'] as int,
      scaid: map['scaid'] as int,
      img: map['img'] != null ? map['img'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      grade: map['current_grade'] != null
          ? (map['current_grade'] as num).toDouble()
          : null,
      simpleGrade: map['simpleGrade'] != null
          ? (map['simpleGrade'] as num).toDouble()
          : null,
      graduated: map['graduated'] != null ? map['graduated'] as int : null,
      incomplete: map['incomplete'] != null ? map['incomplete'] as int : null,
      courseType: map['courseType'] != null ? map['courseType'] as int : null,
      teacher: map['teacher'] != null ? map['teacher'] as String : null,
      active: map['active'] != null ? map['active'] as int : null,
      assignmentActive: map['assignmentActive'] != null
          ? map['assignmentActive'] as int
          : null,
    );
  }
  final homeController = Get.find<HomeController>();

  Future<String> courseStatus(int userId) async {
    print(
      'course id :$cid title :$title incomplete :$incomplete simpleGrade :$simpleGrade',
    );
    if (incomplete == 0 && simpleGrade! != 7 && simpleGrade! >= 2.5) {
      return 'Completed';
    } else if (incomplete == 0 &&
        simpleGrade == 7 &&
        await GradeHelper.hasValidSubmission(userId: userId, aCid: cid)) {
      // print(
      //   'check for submission ${}',
      // );
      return 'In Progress';
    } else if (simpleGrade == 7 && incomplete == 0) {
      return 'Not Started';
    } else if (incomplete! == 1 && simpleGrade! != 7 && simpleGrade! < 2.5) {
      return 'In Complete';
    }

    return '';
  }

  Future<int> courseProgress() async {
    if (grade != 7 &&
        (grade! >= 2.5 || grade == 8) &&
        incomplete == 0 &&
        graduated == 1) {
      return 100;
    } else if (grade == 7 || grade! < 2.5) {
      await GradeHelper.calculateCompletionPercentage(
        userId: homeController.userModel.userId!,
        aCid: cid,
        schoolId: homeController.userModel.schoolId!,
        currentLearningYear: homeController.currentLearningYear.value,
        couresType: courseType!,
      );
    }
    // if (grade == 7 || grade! < 2.5) {

    //   return progress;
    // }
    return 0;
  }

  Future<Map<String, int>> getCourseLp() async {
    return await CoursesHelper.getCourseLp(
      couresType: courseType!,
      currentLearningYear: homeController.currentLearningYear.value,
      schoolId: homeController.userModel.schoolId!,
      cid: cid,
      userId: homeController.userModel.userId!,
    );
  }
}
