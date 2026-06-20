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
import '../../view/sereen/UserScreen/Profile/Screen/profile_screen.dart';
import '../../view/sereen/UserScreen/Wallet/Screen/wallet_screen.dart';
import '../../view/sereen/UserScreen/Wallet/Screen/buy_coins_screen.dart';
import '../../view/sereen/UserScreen/Wallet/Screen/transaction_report_screen.dart';
import '../../view/sereen/UserScreen/Wallet/Screen/support_sent_screen.dart';
import '../../view/sereen/UserScreen/Wallet/Screen/transaction_history_screen.dart';
import '../../view/sereen/UserScreen/Wallet/Screen/transaction_verification_screen.dart';
import '../../view/sereen/UserScreen/Wallet/Screen/support_success_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/add_vehicle_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/edit_profile_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/user_parameters_screen.dart';
import '../../view/sereen/UserScreen/MarketPlace/my_listings_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/edit_vehicle_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/change_password_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/terms_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/privacy_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/help_support_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/about_screen.dart';
import '../../view/sereen/BusinessScreen/BusinessAuth/BusinessRegistration/business_registration_step1.dart';
import '../../view/sereen/BusinessScreen/BusinessAuth/BusinessRegistration/business_registration_step2.dart';
import '../../view/sereen/BusinessScreen/BusinessAuth/BusinessRegistration/business_registration_step3.dart';
import '../../view/sereen/BusinessScreen/BusinessAuth/BusinessRegistration/business_registration_step4.dart';
import '../../view/sereen/BusinessScreen/BusinessHome/Screen/business_dashboard_screen.dart';
import '../../view/sereen/BusinessScreen/BusinessAssetsScreen/Screen/asset_inventory_screen.dart';
import '../../view/sereen/BusinessScreen/BusinessAssetsScreen/Screen/manage_asset_screen.dart';
import '../../view/sereen/BusinessScreen/BusinessAssetsScreen/Screen/edit_listing_screen.dart';
import '../../view/sereen/BusinessScreen/BusinessHome/configure_asset_screen.dart';
import '../../view/sereen/BusinessScreen/BusinessHome/create_parts_listing_screen.dart';
import '../../view/sereen/BusinessScreen/BusinessHome/create_services_listing_screen.dart';
import '../../view/sereen/BusinessScreen/BusiinessSocialHub/business_social_hub_screen.dart';
import '../../view/sereen/BusinessScreen/BusiinessSocialHub/business_create_post_screen.dart';
import '../../view/sereen/BusinessScreen/BusiinessSocialHub/business_create_session_post_screen.dart';
import '../../view/sereen/BusinessScreen/BusiinessSocialHub/business_create_spot_post_screen.dart';
import '../../view/sereen/BusinessScreen/BusiinessSocialHub/business_create_track_update_screen.dart';
import '../../view/sereen/BusinessScreen/BusiinessSocialHub/business_create_club_post_screen.dart';
import '../../view/sereen/BusinessScreen/BusinessMarketPlace/business_marketplace_screen.dart';
import '../../view/sereen/BusinessScreen/BusinessMarketPlace/business_select_category_screen.dart';
import '../../view/sereen/BusinessScreen/BusinessMarketPlace/business_create_vehicle_listing_screen.dart';
import '../../view/sereen/BusinessScreen/BusinessMarketPlace/business_create_motorcycle_listing_screen.dart';
import '../../view/sereen/BusinessScreen/BusinessMarketPlace/business_create_parts_listing_screen.dart';
import '../../view/sereen/BusinessScreen/BusinessMarketPlace/business_create_services_listing_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_create_event_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_events_list_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_event_details_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_clubs_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_profile_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_my_listings_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_club_details_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_create_club_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_edit_club_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_analytics_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_account_settings_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_select_plan_screen.dart';
import '../../view/sereen/BusinessScreen/Promotion/business_promotion_hub_screen.dart';
import '../../view/sereen/BusinessScreen/Promotion/business_create_promotion_screen.dart';








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
  static const String walletScreen = "/WalletScreen";
  static const String buyCoinsScreen = "/BuyCoinsScreen";
  static const String transactionReportScreen = "/TransactionReportScreen";
  static const String supportSentScreen = "/SupportSentScreen";
  static const String transactionHistoryScreen = "/TransactionHistoryScreen";
  static const String transactionVerificationScreen = "/TransactionVerificationScreen";
  static const String supportSuccessScreen = "/SupportSuccessScreen";
  static const String addVehicleScreen = "/AddVehicleScreen";
  static const String editProfileScreen = "/EditProfileScreen";
  static const String userParametersScreen = "/UserParametersScreen";
  static const String myListingsScreen = "/MyListingsScreen";
  static const String editVehicleScreen = "/EditVehicleScreen";
  static const String changePasswordScreen = "/ChangePasswordScreen";
  static const String termsScreen = "/TermsScreen";
  static const String privacyScreen = "/PrivacyScreen";
  static const String helpSupportScreen = "/HelpSupportScreen";
  static const String aboutScreen = "/AboutScreen";
  static const String businessRegistrationStep1 = "/BusinessRegistrationStep1";
  static const String businessRegistrationStep2 = "/BusinessRegistrationStep2";
  static const String businessRegistrationStep3 = "/BusinessRegistrationStep3";
  static const String businessRegistrationStep4 = "/BusinessRegistrationStep4";
  static const String businessHomeScreen = "/BusinessHomeScreen";
  static const String assetInventoryScreen = "/AssetInventoryScreen";
  static const String manageAssetScreen = "/ManageAssetScreen";
  static const String editListingScreen = "/EditListingScreen";
  static const String addAssetCategoryScreen = "/AddAssetCategoryScreen";
  static const String configureAssetScreen = "/ConfigureAssetScreen";
  static const String createPartsListingScreen = "/CreatePartsListingScreen";
  static const String createServicesListingScreen = "/CreateServicesListingScreen";
  static const String businessSocialHubScreen = "/BusinessSocialHubScreen";
  static const String businessCreatePostScreen = "/BusinessCreatePostScreen";
  static const String businessCreateSessionPostScreen = "/BusinessCreateSessionPostScreen";
  static const String businessCreateSpotPostScreen = "/BusinessCreateSpotPostScreen";
  static const String businessCreateTrackUpdateScreen = "/BusinessCreateTrackUpdateScreen";
  static const String businessCreateClubPostScreen = "/BusinessCreateClubPostScreen";
  static const String businessMarketplaceScreen = "/BusinessMarketplaceScreen";
  static const String businessCreateVehicleListingScreen = "/BusinessCreateVehicleListingScreen";
  static const String businessCreateMotorcycleListingScreen = "/BusinessCreateMotorcycleListingScreen";
  static const String businessCreatePartsListingScreen = "/BusinessCreatePartsListingScreen";
  static const String businessCreateServicesListingScreen = "/BusinessCreateServicesListingScreen";
  static const String businessCreateEventScreen = "/BusinessCreateEventScreen";
  static const String businessEventsListScreen = "/BusinessEventsListScreen";
  static const String businessEventDetailsScreen = "/BusinessEventDetailsScreen";
  static const String businessClubsScreen = "/BusinessClubsScreen";
  static const String businessProfileScreen = "/BusinessProfileScreen";
  static const String businessMyListingsScreen = "/BusinessMyListingsScreen";
  static const String businessClubDetailsScreen = "/BusinessClubDetailsScreen";
  static const String businessCreateClubScreen = "/BusinessCreateClubScreen";
  static const String businessEditClubScreen = "/BusinessEditClubScreen";
  static const String businessAnalyticsScreen = "/BusinessAnalyticsScreen";
  static const String businessAccountSettingsScreen = "/BusinessAccountSettingsScreen";
  static const String businessSelectPlanScreen = "/BusinessSelectPlanScreen";
  static const String businessPromotionHubScreen = "/BusinessPromotionHubScreen";
  static const String businessCreatePromotionScreen = "/BusinessCreatePromotionScreen";








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
    GetPage(name: walletScreen, page: () => const WalletScreen()),
    GetPage(name: buyCoinsScreen, page: () => const BuyCoinsScreen()),
    GetPage(name: transactionReportScreen, page: () => const TransactionReportScreen()),
    GetPage(name: supportSentScreen, page: () => const SupportSentScreen()),
    GetPage(name: transactionHistoryScreen, page: () => const TransactionHistoryScreen()),
    GetPage(name: transactionVerificationScreen, page: () => const TransactionVerificationScreen()),
    GetPage(name: supportSuccessScreen, page: () => const SupportSuccessScreen()),
    GetPage(name: addVehicleScreen, page: () => const AddVehicleScreen()),
    GetPage(name: editProfileScreen, page: () => const EditProfileScreen()),
    GetPage(name: userParametersScreen, page: () => const UserParametersScreen()),
    GetPage(name: myListingsScreen, page: () => const MyListingsScreen()),
    GetPage(name: editVehicleScreen, page: () => const EditVehicleScreen()),
    GetPage(name: changePasswordScreen, page: () => const ChangePasswordScreen()),
    GetPage(name: termsScreen, page: () => const TermsScreen()),
    GetPage(name: privacyScreen, page: () => const PrivacyScreen()),
    GetPage(name: helpSupportScreen, page: () => const HelpSupportScreen()),
    GetPage(name: aboutScreen, page: () => const AboutScreen()),
    GetPage(name: businessRegistrationStep1, page: () => const BusinessRegistrationStep1()),
    GetPage(name: businessRegistrationStep2, page: () => const BusinessRegistrationStep2()),
    GetPage(name: businessRegistrationStep3, page: () => const BusinessRegistrationStep3()),
    GetPage(name: businessRegistrationStep4, page: () => const BusinessRegistrationStep4()),
    GetPage(name: businessHomeScreen, page: () => const BusinessHomeScreen()),
    GetPage(name: assetInventoryScreen, page: () => const AssetInventoryScreen()),
    GetPage(name: manageAssetScreen, page: () => const ManageAssetScreen()),
    GetPage(name: editListingScreen, page: () => const EditListingScreen()),
    GetPage(name: addAssetCategoryScreen, page: () => const BusinessSelectCategoryScreen()),
    GetPage(name: configureAssetScreen, page: () => const ConfigureAssetScreen()),
    GetPage(name: createPartsListingScreen, page: () => const CreatePartsListingScreen()),
    GetPage(name: createServicesListingScreen, page: () => const CreateServicesListingScreen()),
    GetPage(name: businessSocialHubScreen, page: () => const BusinessSocialHubScreen()),
    GetPage(name: businessCreatePostScreen, page: () => const BusinessCreatePostScreen()),
    GetPage(name: businessCreateSessionPostScreen, page: () => const BusinessCreateSessionPostScreen()),
    GetPage(name: businessCreateSpotPostScreen, page: () => const BusinessCreateSpotPostScreen()),
    GetPage(name: businessCreateTrackUpdateScreen, page: () => const BusinessCreateTrackUpdateScreen()),
    GetPage(name: businessCreateClubPostScreen, page: () => const BusinessCreateClubPostScreen()),
    GetPage(name: businessMarketplaceScreen, page: () => const BusinessMarketplaceScreen()),
    GetPage(name: businessCreateVehicleListingScreen, page: () => const BusinessCreateVehicleListingScreen()),
    GetPage(name: businessCreateMotorcycleListingScreen, page: () => const BusinessCreateMotorcycleListingScreen()),
    GetPage(name: businessCreatePartsListingScreen, page: () => const BusinessCreatePartsListingScreen()),
    GetPage(name: businessCreateServicesListingScreen, page: () => const BusinessCreateServicesListingScreen()),
    GetPage(name: businessCreateEventScreen, page: () => const BusinessCreateEventScreen()),
    GetPage(name: businessEventsListScreen, page: () => const BusinessEventsListScreen()),
    GetPage(name: businessEventDetailsScreen, page: () => const BusinessEventDetailsScreen()),
    GetPage(name: businessClubsScreen, page: () => const BusinessClubsScreen()),
    GetPage(name: businessProfileScreen, page: () => const BusinessProfileScreen()),
    GetPage(name: businessMyListingsScreen, page: () => const BusinessMyListingsScreen()),
    GetPage(name: businessClubDetailsScreen, page: () => const BusinessClubDetailsScreen()),
    GetPage(name: businessCreateClubScreen, page: () => const BusinessCreateClubScreen()),
    GetPage(name: businessEditClubScreen, page: () => const BusinessEditClubScreen()),
    GetPage(name: businessAnalyticsScreen, page: () => const BusinessAnalyticsScreen()),
    GetPage(name: businessAccountSettingsScreen, page: () => const BusinessAccountSettingsScreen()),
    GetPage(name: businessSelectPlanScreen, page: () => const BusinessSelectPlanScreen()),
    GetPage(name: businessPromotionHubScreen, page: () => const BusinessPromotionHubScreen()),
    GetPage(name: businessCreatePromotionScreen, page: () => const BusinessCreatePromotionScreen()),
  ];

}
