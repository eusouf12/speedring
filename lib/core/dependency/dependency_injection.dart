import 'package:get/get.dart';
import 'package:speedring/view/sereen/AuthScreen/controller/auth_controller.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/MessageScreen/controller/message_screen_controller.dart';
import 'package:speedring/view/sereen/UserScreen/Profile/Screen/help_support_screen.dart';
import 'package:speedring/view/sereen/UserScreen/Profile/controller/settings_controller.dart';
import 'package:speedring/view/sereen/UserScreen/Profile/controller/single_profile_controller.dart';
import 'package:speedring/view/sereen/UserScreen/discover/controller/discover_controller.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/controller/reels_controller.dart';
import '../../view/sereen/BusinessScreen/BusinessAuth/controller/business_registration_controller.dart';
import '../../view/sereen/SetupProfile/setup_profile_controller.dart';
import '../../view/sereen/BusinessScreen/BusinessHome/Controller/business_dashboard_controller.dart';
import '../../view/sereen/UserScreen/MarketPlace/controller/marketpace_controller.dart';
import '../../view/sereen/UserScreen/Profile/controller/manage_web_controller.dart';
import '../../view/sereen/UserScreen/Profile/controller/profile_controller.dart';
import '../../view/sereen/UserScreen/Wallet/controller/support_controller.dart';
import '../../view/sereen/UserScreen/Wallet/controller/transaction_history_controller.dart';
import '../../view/sereen/UserScreen/Wallet/controller/send_support_controller.dart';
import '../../view/sereen/UserScreen/track/controller/track_controller.dart';
import 'package:speedring/view/components/share/share_controller.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    ///========================== Default Custom Controller ==================
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => SetupProfileController(), fenix: true);
    Get.put(ProfileScreenController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(ReelsController(), permanent: true);
    Get.lazyPut(() => DiscoverController(), fenix: true);
    Get.lazyPut(() => MarketplaceFeedController(), fenix: true);
    Get.put(BusinessDashboardController(), permanent: true);
    Get.lazyPut(() => TrackController(), fenix: true);
    Get.lazyPut(() => SupportController(), fenix: true);
    Get.lazyPut(() => TransactionHistoryController(), fenix: true);
    Get.lazyPut(() => SendSupportController(), fenix: true);
    Get.lazyPut(() => SingleProfileController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
    Get.lazyPut(() => BusinessRegistrationController(), fenix: true);
    Get.lazyPut(() => ManageWebController(), fenix: true);
    Get.lazyPut(() => HelpSupportController(), fenix: true);
    Get.lazyPut(() => ShareController(), fenix: true);
    Get.lazyPut(() => MessageScreenController(), fenix: true);
  }
}
