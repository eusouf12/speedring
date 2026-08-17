import 'package:get/get.dart';
import '../../core/app_routes/app_routes.dart';
import '../view/sereen/UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';

class NavigationUtils {
  static void navigateToUserProfile(String? userId) {
    if (userId == null || userId.isEmpty) return;

    final isMyProfile = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>().currentUserId.value == userId
        : false; // Fallback, though HomeController should usually be registered

    if (isMyProfile) {
      Get.toNamed(AppRoutes.profileScreen);
    } else {
      Get.toNamed(AppRoutes.singleProfileScreen, arguments: userId);
    }
  }
}
