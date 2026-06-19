import 'package:get/get.dart';
import 'package:speedring/view/sereen/AuthScreen/controller/auth_controller.dart';
import '../../view/sereen/OnboardingScreen/widget/on_bording_controller.dart';
import '../../view/sereen/SetupProfile/setup_profile_controller.dart';
import '../../view/sereen/BusinessScreen/BusinessHome/Controller/business_dashboard_controller.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    ///========================== Default Custom Controller ==================
    Get.lazyPut(() => OnboardingController(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => SetupProfileController(), fenix: true);
    Get.put(BusinessDashboardController(), permanent: true);
  }
}