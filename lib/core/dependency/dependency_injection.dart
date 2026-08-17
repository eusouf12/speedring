import 'package:get/get.dart';
import 'package:speedring/view/sereen/AuthScreen/controller/auth_controller.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';
import 'package:speedring/view/sereen/UserScreen/Profile/controller/settings_controller.dart';
import 'package:speedring/view/sereen/UserScreen/Profile/controller/single_profile_controller.dart';
import 'package:speedring/view/sereen/UserScreen/discover/controller/discover_controller.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/controller/reels_controller.dart';
import '../../view/sereen/SetupProfile/setup_profile_controller.dart';
import '../../view/sereen/BusinessScreen/BusinessHome/Controller/business_dashboard_controller.dart';
import '../../view/sereen/UserScreen/MarketPlace/controller/marketpace_controller.dart';
import '../../view/sereen/UserScreen/Profile/controller/profile_controller.dart';
import '../../view/sereen/UserScreen/Wallet/controller/support_controller.dart';
import '../../view/sereen/UserScreen/Wallet/controller/transaction_history_controller.dart';
import '../../view/sereen/UserScreen/Wallet/controller/send_support_controller.dart';
import '../../view/sereen/UserScreen/track/controller/track_controller.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    ///========================== Default Custom Controller ==================
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => SetupProfileController(), fenix: true);
    Get.lazyPut(() => ProfileScreenController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => ReelsController(), fenix: true);
    Get.lazyPut(() => DiscoverController(), fenix: true);
    Get.lazyPut(() => MarketplaceFeedController(), fenix: true);
    Get.put(BusinessDashboardController(), permanent: true);
    Get.lazyPut(() => TrackController(), fenix: true);
    Get.lazyPut(() => SupportController(), fenix: true);
    Get.lazyPut(() => TransactionHistoryController(), fenix: true);
    Get.lazyPut(() => SendSupportController(), fenix: true);
    Get.lazyPut(() => SingleProfileController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
  }
}
