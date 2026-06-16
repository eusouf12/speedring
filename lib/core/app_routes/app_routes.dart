import 'package:get/get.dart';
import '../../view/sereen/OnboardingScreen/age_verify_screen.dart';
import '../../view/sereen/OnboardingScreen/code_request.dart';
import '../../view/sereen/SetupProfile/preview.dart';
import '../../view/sereen/SetupProfile/setup_profile_screen.dart';
import '../../view/sereen/SetupProfile/setup_profile_screen2.dart';
import '../../view/sereen/SetupProfile/setup_profile_screen3.dart';
import '../../view/sereen/SetupProfile/setup_profile_screen4.dart' show SetupProfileScreen4;
import '../../view/sereen/SplashScreen/splashScreen.dart';
import '../../view/sereen/OnboardingScreen/onboarding_screen.dart';
import '../../view/sereen/AuthScreen/LoginScreen/login_screen.dart';
import '../../view/sereen/OnboardingScreen/choose_plan_screen.dart';
import '../../view/sereen/AuthScreen/SignupScreen/signup_screen.dart';
import '../../view/sereen/AuthScreen/ForgotPasswordScreen/forgot_password_screen.dart';
import '../../view/sereen/AuthScreen/VerifyOtpScreen/verify_otp_screen.dart';
import '../../view/sereen/AuthScreen/ResetPasswordScreen/reset_password_screen.dart';
import '../../view/sereen/UserScreen/Home/HomeScreen/clubs/club_details_screen.dart';
import '../../view/sereen/UserScreen/Home/HomeScreen/user_home_screen.dart';
import '../../view/sereen/UserScreen/Home/NotificationScreen/notification_screen.dart';
import '../../view/sereen/UserScreen/Home/MessageScreen/message_screen.dart';
import '../../view/sereen/UserScreen/Home/MessageScreen/inbox_screen.dart';
import '../../view/sereen/UserScreen/Home/HomeScreen/event_detail_screen.dart';
import '../../view/sereen/UserScreen/Home/HomeScreen/access_granted_screen.dart';
import '../../view/sereen/UserScreen/Home/HomeScreen/clubs/create_club_screen.dart';
import '../../view/sereen/UserScreen/Home/HomeScreen/clubs/edit_club_screen.dart';
import '../../view/sereen/UserScreen/Home/HomeScreen/create_post_screen.dart';
import '../../view/sereen/UserScreen/Home/HomeScreen/clubs/club_post_screen.dart';





class AppRoutes {
  ///===========================Authentication==========================
  static const String splashScreen = "/SplashScreen";
  static const String onboardingScreen = "/OnboardingScreen";
  static const String loginScreen = "/LoginScreen";
  static const String signupScreen = "/SignupScreen";
  static const String forgotPasswordScreen = "/ForgotPasswordScreen";
  static const String verifyOtpScreen = "/VerifyOtpScreen";
  static const String choosePlanScreen = "/ChoosePlanScreen";
  static const String resetPasswordScreen = "/ResetPasswordScreen";
  static const String codeRequest = "/CodeRequest";
  static const String ageVerifyScreen = "/AgeVerifyScreen";
  static const String setupProfileScreen1 = "/SetupProfileScreen1";
  static const String setupProfileScreen2 = "/SetupProfileScreen2";
  static const String setupProfileScreen3 = "/SetupProfileScreen3";
  static const String setupProfileScreen4 = "/SetupProfileScreen4";
  static const String preview = "/GaragePreparationScreen";
  static const String userHomeScreen = "/UserHomeScreen";
  static const String notificationScreen = "/NotificationScreen";
  static const String messageScreen = "/MessageScreen";
  static const String inboxScreen = "/InboxScreen";
  static const String eventDetailScreen = "/EventDetailScreen";
  static const String accessGrantedScreen = "/AccessGrantedScreen";
  static const String createClubScreen = "/CreateClubScreen";
  static const String editClubScreen = "/EditClubScreen";
  static const String clubDetailsScreen = "/ClubDetailsScreen";
  static const String createPostScreen = "/CreatePostScreen";
  static const String clubPostScreen = "/ClubPostScreen";





  static List<GetPage> routes = [
    ///===========================Authentication==========================
    GetPage(name: splashScreen, page: () => const SplashScreen()),

    ///============== User part ==================
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(name: codeRequest, page: () => const CodeRequest()),
    GetPage(name: ageVerifyScreen, page: () => const AgeVerifyScreen()),
    GetPage(name: setupProfileScreen1, page: () => const SetupProfileScreen1()),
    GetPage(name: setupProfileScreen2, page: () => const SetupProfileScreen2()),
    GetPage(name: setupProfileScreen3, page: () => const SetupProfileScreen3()),
     GetPage(name: setupProfileScreen4, page: () => const SetupProfileScreen4()),
    GetPage(name: choosePlanScreen, page: () => const ChoosePlanScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: signupScreen, page: () => SignupScreen()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(name: verifyOtpScreen, page: () => VerifyOtpScreen()),
    GetPage(name: resetPasswordScreen, page: () => ResetPasswordScreen()),
    GetPage(name: preview, page: () => GaragePreparationScreen()),
    GetPage(name: userHomeScreen, page: () => UserHomeScreen()),
    GetPage(name: notificationScreen, page: () => const NotificationScreen()),
    GetPage(name: messageScreen, page: () => const MessageScreen()),
    GetPage(name: inboxScreen, page: () => InboxScreen(
      userName: Get.arguments?["userName"] ?? "Driver",
      avatarUrl: Get.arguments?["avatarUrl"] ?? "https://picsum.photos/100/100",
      isOnline: Get.arguments?["isOnline"] ?? false,
    )),
    GetPage(name: eventDetailScreen, page: () => const EventDetailScreen()),
    GetPage(name: accessGrantedScreen, page: () => const AccessGrantedScreen()),
    GetPage(name: createClubScreen, page: () => const CreateClubScreen()),
    GetPage(name: editClubScreen, page: () => const EditClubScreen()),
    GetPage(name: clubDetailsScreen, page: () => const ClubDetailsScreen()),
    GetPage(name: createPostScreen, page: () => CreatePostScreen()),
    GetPage(name: clubPostScreen, page: () => const ClubPostScreen()),

  ];
}

