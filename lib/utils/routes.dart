import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:lms_student/features/auth/binding/login_binding.dart';
import 'package:lms_student/features/auth/view/login_page.dart';
import 'package:lms_student/features/courses/controllers/courses_binding.dart';
import 'package:lms_student/features/formative_assessment/view/formatives_page.dart';
import 'package:lms_student/features/learning_journey/view/quill_page.dart';
import 'package:lms_student/features/summative_assessment/view/sa_input_page.dart';
import 'package:lms_student/features/summative_assessment/view/sa_link_page.dart';
import 'package:lms_student/features/summative_assessment/view/summative_assessment_page.dart'
    show SummativeAssessmentPage;
import 'package:lms_student/features/summatives/view/all_journeyes_page.dart';
import 'package:lms_student/features/summatives/view/summative_page.dart';
import 'package:lms_student/features/courses/view/courses_page.dart';
import 'package:lms_student/features/grades/view/grades_page.dart';
import 'package:lms_student/features/home/home.dart';
import 'package:lms_student/features/home/view/home_page.dart';
import 'package:lms_student/features/formative_assessment/view/fa_input_page.dart';
import 'package:lms_student/features/formative_assessment/view/fa_link_page.dart';
import 'package:lms_student/features/formative_assessment/view/formative_assessment_page.dart';
import 'package:lms_student/features/learning_journey/view/journey_page.dart';
import 'package:lms_student/features/learning_journey/view/kwl_page.dart';
import 'package:lms_student/features/learning_journey/view/lesson_materiel_page.dart';
import 'package:lms_student/features/learning_journey/view/prior_knowledge_page.dart';
import 'package:lms_student/features/messages/view/chat_page.dart';
import 'package:lms_student/features/messages/view/messaging_page.dart';
import 'package:lms_student/features/notifications/view/notifications_page.dart';
import 'package:lms_student/features/profile/bindings/edit_profile_binding.dart';
import 'package:lms_student/features/profile/bindings/profile_binding.dart';
import 'package:lms_student/features/profile/view/edit_profile_page.dart';
import 'package:lms_student/features/profile/view/profile_page.dart';
import 'package:lms_student/features/transript/view/transcript_page.dart';

final routes = [
  GetPage(
    name: LoginPage.routeName,
    page: () => LoginPage(),
    binding: LoginBinding(),
  ),
  GetPage(name: Home.routeName, page: () => Home()),
  GetPage(name: HomePage.routeName, page: () => HomePage()),
  GetPage(name: CoursesPage.routeName, page: () => CoursesPage()),
  GetPage(name: GradesPage.routeName, page: () => GradesPage()),
  GetPage(name: TranscriptPage.routeName, page: () => TranscriptPage()),
  GetPage(
    name: ProfilePage.routeName,
    page: () => ProfilePage(),
    binding: ProfileBinding(),
  ),
  GetPage(
    name: JourneyPage.routeName,
    page: () => JourneyPage(journey: Get.arguments),
  ),
  GetPage(
    name: SummativePage.routeName,
    page: () {
      return SummativePage(course: Get.arguments);
    },
  ),
  GetPage(
    name: PriorKnowledgePage.routeName,
    page: () => PriorKnowledgePage(lesson: Get.arguments),
  ),
  GetPage(
    name: LessonMaterielPage.routeName,
    page: () => LessonMaterielPage(lesson: Get.arguments),
  ),
  GetPage(name: KwlPage.routeName, page: () => KwlPage()),
  GetPage(
    name: FaLinkPage.routeName,
    page: () => FaLinkPage(
      lesson: Get.arguments[0],
      journey: Get.arguments[1],
      formative: Get.arguments[2],
    ),
  ),
  GetPage(
    name: FaInputPage.routeName,
    page: () => FaInputPage(
      lesson: Get.arguments[0],
      journey: Get.arguments[1],
      formative: Get.arguments[2],
    ),
  ),
  GetPage(
    name: FormativeAssessmentPage.routeName,
    page: () => FormativeAssessmentPage(
      lesson: Get.arguments[0],
      journey: Get.arguments[1],
      formative: Get.arguments[2],
    ),
  ),
  GetPage(
    name: SummativeAssessmentPage.routeName,
    page: () => SummativeAssessmentPage(journey: Get.arguments),
  ),
  GetPage(name: MessagingPage.routeName, page: () => MessagingPage()),
  //GetPage(name: ChatPage.routeName, page: () => ChatPage()),
  GetPage(name: NotificationsPage.routeName, page: () => NotificationsPage()),
  GetPage(
    name: EditProfilePage.routeName,
    page: () => EditProfilePage(user: Get.arguments),
    binding: EditProfileBinding(),
  ),
  GetPage(
    name: AllJourneyesPage.routeName,
    page: () => AllJourneyesPage(journeyes: Get.arguments),
  ),
  GetPage(
    name: QuillPage.routeName,
    page: () => QuillPage(text: Get.arguments[0], lesson: Get.arguments[1]),
  ),
  GetPage(
    name: SaInputPage.routeName,
    page: () => SaInputPage(journey: Get.arguments),
  ),
  GetPage(
    name: SaLinkPage.routeName,
    page: () => SaLinkPage(journey: Get.arguments),
  ),
  GetPage(
    name: FormativesPage.routeName,
    page: () =>
        FormativesPage(lesson: Get.arguments[0], journey: Get.arguments[1]),
  ),
];
