import 'package:get/get.dart';
import '../../view/sereen/SplashScreen/splashScreen.dart';
import '../../view/sereen/OnboardingScreen/onboarding_screen.dart';
import '../../view/sereen/AuthScreen/LoginScreen/login_screen.dart';

class AppRoutes {
  ///===========================Authentication==========================
  static const String splashScreen = "/SplashScreen";
  static const String onboardingScreen = "/OnboardingScreen";
  static const String loginScreen = "/LoginScreen";

 




  static List<GetPage> routes = [

    ///===========================Authentication==========================
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    

    ///============== User part ==================
    GetPage(name: onboardingScreen, page: () =>  OnboardingScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
   
  ];
}
