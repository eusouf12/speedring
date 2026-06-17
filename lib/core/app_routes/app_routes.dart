import 'package:get/get.dart';
import '../../view/sereen/OnboardingScreen/age_verify_screen.dart';
import '../../view/sereen/OnboardingScreen/code_request.dart';
import '../../view/sereen/SetupProfile/preview.dart';
import '../../view/sereen/SetupProfile/setup_profile_screen.dart';
import '../../view/sereen/SetupProfile/setup_profile_screen2.dart';
import '../../view/sereen/SetupProfile/setup_profile_screen3.dart';
import '../../view/sereen/SetupProfile/setup_profile_screen4.dart' show SetupProfileScreen4;
import '../../view/sereen/SplashScreen/splash_screen.dart';
import '../../view/sereen/OnboardingScreen/onboarding_screen.dart';
import '../../view/sereen/AuthScreen/LoginScreen/login_screen.dart';
import '../../view/sereen/OnboardingScreen/choose_plan_screen.dart';
import '../../view/sereen/AuthScreen/SignupScreen/signup_screen.dart';
import '../../view/sereen/AuthScreen/ForgotPasswordScreen/forgot_password_screen.dart';
import '../../view/sereen/AuthScreen/VerifyOtpScreen/verify_otp_screen.dart';
import '../../view/sereen/AuthScreen/ResetPasswordScreen/reset_password_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/clubs/club_details_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/user_home_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/NotificationScreen/notification_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/MessageScreen/message_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/MessageScreen/inbox_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/event_detail_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/access_granted_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/clubs/create_club_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/clubs/edit_club_screen.dart';
import '../../view/sereen/UserScreen/track/track_hub_screen.dart';
import '../../view/sereen/UserScreen/track/prepare_session_screen.dart';
import '../../view/sereen/UserScreen/track/live_session_screen.dart';
import '../../view/sereen/UserScreen/track/drive_summary_screen.dart';
import '../../view/sereen/UserScreen/track/find_track_screen.dart';
import '../../view/sereen/UserScreen/track/group_drives/group_drives_screen.dart';
import '../../view/sereen/UserScreen/track/group_drives/trip_configurator_screen.dart';
import '../../view/sereen/UserScreen/track/group_drives/trip_lobby_screen.dart';
import '../../view/sereen/UserScreen/track/group_drives/active_drive_screen.dart';
import '../../view/sereen/UserScreen/track/group_drives/end_expedition_screen.dart';
import '../../view/sereen/UserScreen/track/group_drives/share_expedition_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/create_post_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/clubs/club_post_screen.dart';
import '../../view/sereen/UserScreen/discover/add_spot_screen.dart';
import '../../view/sereen/UserScreen/discover/add_video_screen.dart';
import '../../view/sereen/UserScreen/discover/discover_screen.dart';
import '../../view/sereen/UserScreen/MarketPlace/marketplace_feed_screen.dart';
import '../../view/sereen/UserScreen/MarketPlace/item_detail_screen.dart';
import '../../view/sereen/UserScreen/MarketPlace/select_category_screen.dart';
import '../../view/sereen/UserScreen/MarketPlace/create_vehicle_listing_screen.dart';
import '../../view/sereen/UserScreen/MarketPlace/create_motorcycle_listing_screen.dart';
import '../../view/sereen/UserScreen/Profile/profile_screen.dart';
import '../../view/sereen/UserScreen/Profile/add_vehicle_screen.dart';
import '../../view/sereen/UserScreen/Profile/edit_profile_screen.dart';
import '../../view/sereen/UserScreen/Profile/user_parameters_screen.dart';
import '../../view/sereen/UserScreen/MarketPlace/my_listings_screen.dart';
import '../../view/sereen/UserScreen/Profile/edit_vehicle_screen.dart';








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
  static const String discoverScreen = "/DiscoverScreen";
  static const String addSpotScreen = "/AddSpotScreen";
  static const String addVideoScreen = "/AddVideoScreen";
  static const String trackHubScreen = "/TrackHubScreen";
  static const String prepareSessionScreen = "/PrepareSessionScreen";
  static const String liveSessionScreen = "/LiveSessionScreen";
  static const String driveSummaryScreen = "/DriveSummaryScreen";
  static const String findTrackScreen = "/FindTrackScreen";
  static const String groupDrivesScreen = "/GroupDrivesScreen";
  static const String tripConfiguratorScreen = "/TripConfiguratorScreen";
  static const String tripLobbyScreen = "/TripLobbyScreen";
  static const String activeDriveScreen = "/ActiveDriveScreen";
  static const String endExpeditionScreen = "/EndExpeditionScreen";
  static const String shareExpeditionScreen = "/ShareExpeditionScreen";
  static const String clubDetailsScreen = "/ClubDetailsScreen";
  static const String createPostScreen = "/CreatePostScreen";
  static const String clubPostScreen = "/ClubPostScreen";
  static const String marketplaceFeedScreen = "/MarketplaceFeedScreen";
  static const String itemDetailScreen = "/ItemDetailScreen";
  static const String selectCategoryScreen = "/SelectCategoryScreen";
  static const String createVehicleListingScreen = "/CreateVehicleListingScreen";
  static const String createMotorcycleListingScreen = "/CreateMotorcycleListingScreen";
  static const String profileScreen = "/ProfileScreen";
  static const String addVehicleScreen = "/AddVehicleScreen";
  static const String editProfileScreen = "/EditProfileScreen";
  static const String userParametersScreen = "/UserParametersScreen";
  static const String myListingsScreen = "/MyListingsScreen";
  static const String editVehicleScreen = "/EditVehicleScreen";







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
    GetPage(name: discoverScreen, page: () => const DiscoverScreen()),
    GetPage(name: addSpotScreen, page: () => const AddSpotScreen()),
    GetPage(name: addVideoScreen, page: () => const AddVideoScreen()),
    GetPage(name: trackHubScreen, page: () => const TrackHubScreen()),
    GetPage(name: prepareSessionScreen, page: () => const PrepareSessionScreen()),
    GetPage(name: liveSessionScreen, page: () => const LiveSessionScreen()),
    GetPage(name: driveSummaryScreen, page: () => const DriveSummaryScreen()),
    GetPage(name: findTrackScreen, page: () => const FindTrackScreen()),
    GetPage(name: groupDrivesScreen, page: () => const GroupDrivesScreen()),
    GetPage(name: tripConfiguratorScreen, page: () => const TripConfiguratorScreen()),
    GetPage(name: tripLobbyScreen, page: () => const TripLobbyScreen()),
    GetPage(name: activeDriveScreen, page: () => const ActiveDriveScreen()),
    GetPage(name: endExpeditionScreen, page: () => const EndExpeditionScreen()),
    GetPage(name: shareExpeditionScreen, page: () => const ShareExpeditionScreen()),
    GetPage(name: clubDetailsScreen, page: () => const ClubDetailsScreen()),
    GetPage(name: createPostScreen, page: () => CreatePostScreen()),
    GetPage(name: clubPostScreen, page: () => const ClubPostScreen()),
    GetPage(name: marketplaceFeedScreen, page: () => const MarketplaceListingFeedScreen()),
    GetPage(name: itemDetailScreen, page: () => const ItemDetailScreen()),
    GetPage(name: selectCategoryScreen, page: () => const SelectCategoryScreen()),
    GetPage(name: createVehicleListingScreen, page: () => const CreateVehicleListingScreen()),
    GetPage(name: createMotorcycleListingScreen, page: () => const CreateMotorcycleListingScreen()),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: addVehicleScreen, page: () => const AddVehicleScreen()),
    GetPage(name: editProfileScreen, page: () => const EditProfileScreen()),
    GetPage(name: userParametersScreen, page: () => const UserParametersScreen()),
    GetPage(name: myListingsScreen, page: () => const MyListingsScreen()),
    GetPage(name: editVehicleScreen, page: () => const EditVehicleScreen()),
  ];

}
