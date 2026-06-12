import 'package:get/get.dart';

import '../../view/sereen/OnboardingScreen/widget/on_bording_controller.dart';
class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    ///========================== Default Custom Controller ==================

     //Get.lazyPut(() => AuthController(), fenix: true);
    // Get.lazyPut(() => ProfileController(), fenix: true);
    // Get.lazyPut(() => SocialController(), fenix: true);
    // Get.lazyPut(() => HomeController(), fenix: true);
    // ///========================== Event Part Controller ==================
    Get.lazyPut(() => OnboardingController(), fenix: true);
    
  }
}