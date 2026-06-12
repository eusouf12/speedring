import 'package:get/get.dart';
import '../../view/sereen/SplashScreen/splashScreen.dart';
import '../../view/sereen/OnboardingScreen/onboarding_screen.dart';

class AppRoutes {
  ///===========================Authentication==========================
  static const String splashScreen = "/SplashScreen";
  static const String onboardingScreen = "/OnboardingScreen";

 




  static List<GetPage> routes = [

    ///===========================Authentication==========================
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    

    ///============== User part ==================
    GetPage(name: onboardingScreen, page: () =>  OnboardingScreen()),
   
  ];
}
