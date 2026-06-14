import 'package:get/get.dart';
import '../../view/sereen/SplashScreen/splashScreen.dart';
import '../../view/sereen/OnboardingScreen/onboarding_screen.dart';
import '../../view/sereen/AuthScreen/LoginScreen/login_screen.dart';
import '../../view/sereen/AuthScreen/SignupScreen/signup_screen.dart';
import '../../view/sereen/AuthScreen/ForgotPasswordScreen/forgot_password_screen.dart';
import '../../view/sereen/AuthScreen/VerifyOtpScreen/verify_otp_screen.dart';
import '../../view/sereen/AuthScreen/ResetPasswordScreen/reset_password_screen.dart';

class AppRoutes {
  ///===========================Authentication==========================
  static const String splashScreen = "/SplashScreen";
  static const String onboardingScreen = "/OnboardingScreen";
  static const String loginScreen = "/LoginScreen";
  static const String signupScreen = "/SignupScreen";
  static const String forgotPasswordScreen = "/ForgotPasswordScreen";
  static const String verifyOtpScreen = "/VerifyOtpScreen";
  static const String resetPasswordScreen = "/ResetPasswordScreen";

  static List<GetPage> routes = [
    ///===========================Authentication==========================
    GetPage(name: splashScreen, page: () => const SplashScreen()),

    ///============== User part ==================
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: signupScreen, page: () => SignupScreen()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(name: verifyOtpScreen, page: () => VerifyOtpScreen()),
    GetPage(name: resetPasswordScreen, page: () => ResetPasswordScreen()),
  ];
}
