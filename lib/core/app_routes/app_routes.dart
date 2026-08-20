import 'package:get/get.dart';
import '../../view/sereen/BusinessScreen/BusinessHome/Screen/business_dashboard_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Event/business_my_event_screen.dart';
import '../../view/sereen/OnboardingScreen/age_verify_screen.dart';
import '../../view/sereen/OnboardingScreen/widget/on_bording_controller.dart';
import '../../view/sereen/SetupProfile/preview.dart';
import '../../view/sereen/SetupProfile/setup_profile_screen.dart';
import '../../view/sereen/SetupProfile/setup_profile_screen2.dart';
import '../../view/sereen/SetupProfile/setup_profile_screen3.dart';
import '../../view/sereen/SetupProfile/setup_profile_screen4.dart'
    show SetupProfileScreen4;
import '../../view/sereen/SplashScreen/splash_screen.dart';
import '../../view/sereen/OnboardingScreen/onboarding_screen.dart';
import '../../view/sereen/AuthScreen/LoginScreen/login_screen.dart';
import '../../view/sereen/OnboardingScreen/choose_plan_screen.dart';
import '../../view/sereen/AuthScreen/SignupScreen/signup_screen.dart';
import '../../view/sereen/AuthScreen/ForgotPasswordScreen/forgot_password_screen.dart';
import '../../view/sereen/AuthScreen/VerifyOtpScreen/verify_otp_screen.dart';
import '../../view/sereen/AuthScreen/ResetPasswordScreen/reset_password_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/clubs/club_details_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/clubs/club_detaisl_screen_non_my.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/clubs/club_members_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/clubs/club_join_requests_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/clubs/club_group_post_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/user_home_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/reel/reels_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/reel/create_reel_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/NotificationScreen/notification_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/MessageScreen/message_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/MessageScreen/inbox_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/MessageScreen/support_member_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/event/event_detail_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/access_granted_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/clubs/create_club_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/clubs/edit_club_screen.dart';
import '../../view/sereen/UserScreen/track/view/track_hub_screen.dart';
import '../../view/sereen/UserScreen/track/view/single_track/prepare_session_screen.dart';
import '../../view/sereen/UserScreen/track/view/single_track/live_session_screen.dart';
import '../../view/sereen/UserScreen/track/view/single_track/drive_summary_screen.dart';
import '../../view/sereen/UserScreen/track/view/single_track/find_track_screen.dart';
import '../../view/sereen/UserScreen/track/view/group_drives/group_drives_screen.dart';
import '../../view/sereen/UserScreen/track/view/group_drives/trip_configurator_screen.dart';
import '../../view/sereen/UserScreen/track/view/group_drives/trip_lobby_screen.dart';
import '../../view/sereen/UserScreen/track/view/group_drives/active_drive_screen.dart';
import '../../view/sereen/UserScreen/track/view/group_drives/end_expedition_screen.dart';
import '../../view/sereen/UserScreen/track/view/group_drives/share_expedition_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/post/create_post_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/post/club_post_screen.dart';
import '../../view/sereen/UserScreen/discover/view/add_spot_screen.dart';
import '../../view/sereen/UserScreen/discover/view/edit_spot_screen.dart';
import '../../view/sereen/UserScreen/discover/view/add_video_screen.dart';
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/event/create_event_screen.dart';
import '../../view/sereen/UserScreen/discover/view/discover_screen.dart';
import '../../view/sereen/UserScreen/MarketPlace/view/marketplace_feed_screen.dart';
import '../../view/sereen/UserScreen/MarketPlace/view/item_detail_screen.dart';
import '../../view/sereen/UserScreen/MarketPlace/view/select_category_screen.dart';
import '../../view/sereen/UserScreen/MarketPlace/view/create_vehicle_listing_screen.dart';
import '../../view/sereen/UserScreen/MarketPlace/view/create_motorcycle_listing_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/profile_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/single_profile_screen.dart';
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
import '../../view/sereen/UserScreen/MarketPlace/view/my_listings_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/edit_vehicle_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/change_password_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/terms_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/privacy_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/help_support_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/about_screen.dart';
import '../../view/sereen/UserScreen/Profile/Screen/personalize_interest_screen.dart';
import '../../view/sereen/UserScreen/track/view/single_track/my_sessions_screen.dart'
    as speedring_my_sessions;
import '../../view/sereen/UserScreen/Home/Screen/HomeScreen/view/reel/saved_reels_screen.dart';
import '../../view/sereen/BusinessScreen/BusinessAuth/BusinessRegistration/business_registration_step1.dart';
import '../../view/sereen/BusinessScreen/BusinessAuth/BusinessRegistration/business_registration_step2.dart';
import '../../view/sereen/BusinessScreen/BusinessAuth/BusinessRegistration/business_registration_step3.dart';
import '../../view/sereen/BusinessScreen/BusinessAuth/BusinessRegistration/business_registration_step4.dart';
import '../../view/sereen/BusinessScreen/Business_club_screen/business_clubs_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_profile_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_analytics_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_account_settings_screen.dart';
import '../../view/sereen/BusinessScreen/Business_Profile/business_select_plan_screen.dart';
import '../../view/sereen/BusinessScreen/Promotion/business_promotion_hub_screen.dart';
import '../../view/sereen/BusinessScreen/Promotion/business_create_promotion_screen.dart';
import '../../view/sereen/UserScreen/track/view/single_track/track_details_screen.dart';

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
  static const String supportMemberScreen = "/SupportMemberScreen";
  static const String eventDetailScreen = "/EventDetailScreen";
  static const String accessGrantedScreen = "/AccessGrantedScreen";
  static const String createClubScreen = "/CreateClubScreen";
  static const String editClubScreen = "/EditClubScreen";
  static const String discoverScreen = "/DiscoverScreen";
  static const String addSpotScreen = "/AddSpotScreen";
  static const String editSpotScreen = "/EditSpotScreen";
  static const String addVideoScreen = "/AddVideoScreen";
  static const String createEventScreen = "/CreateEventScreen";
  static const String trackHubScreen = "/TrackHubScreen";
  static const String prepareSessionScreen = "/PrepareSessionScreen";
  static const String liveSessionScreen = "/LiveSessionScreen";
  static const String driveSummaryScreen = "/DriveSummaryScreen";
  static const String findTrackScreen = "/FindTrackScreen";
  static const String trackDetailsScreen = "/TrackDetailsScreen";
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
  static const String createVehicleListingScreen =
      "/CreateVehicleListingScreen";
  static const String createMotorcycleListingScreen =
      "/CreateMotorcycleListingScreen";
  static const String profileScreen = "/ProfileScreen";
  static const String singleProfileScreen = "/SingleProfileScreen";
  static const String walletScreen = "/WalletScreen";
  static const String buyCoinsScreen = "/BuyCoinsScreen";
  static const String transactionReportScreen = "/TransactionReportScreen";
  static const String supportSentScreen = "/SupportSentScreen";
  static const String transactionHistoryScreen = "/TransactionHistoryScreen";
  static const String paymentWebviewScreen = "/PaymentWebviewScreen";
  static const String transactionVerificationScreen =
      "/TransactionVerificationScreen";
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
  static const String personalizeInterestScreen = "/PersonalizeInterestScreen";
  static const String businessRegistrationStep1 = "/BusinessRegistrationStep1";
  static const String businessRegistrationStep2 = "/BusinessRegistrationStep2";
  static const String businessRegistrationStep3 = "/BusinessRegistrationStep3";
  static const String businessRegistrationStep4 = "/BusinessRegistrationStep4";
  static const String businessMyEventScreen = "/BusinessMyEventScreen";
  static const String businessHomeScreen = "/BusinessHomeScreen";
  static const String assetInventoryScreen = "/AssetInventoryScreen";
  static const String manageAssetScreen = "/ManageAssetScreen";
  static const String editListingScreen = "/EditListingScreen";
  static const String addAssetCategoryScreen = "/AddAssetCategoryScreen";
  static const String businessSocialHubScreen = "/BusinessSocialHubScreen";
  static const String businessMarketplaceScreen = "/BusinessMarketplaceScreen";
  static const String businessCreateEventScreen = "/BusinessCreateEventScreen";
  static const String businessEventsListScreen = "/BusinessEventsListScreen";
  static const String businessClubsScreen = "/BusinessClubsScreen";
  static const String businessProfileScreen = "/BusinessProfileScreen";
  static const String businessClubDetailsScreen = "/BusinessClubDetailsScreen";
  static const String businessCreateClubScreen = "/BusinessCreateClubScreen";
  static const String businessEditClubScreen = "/BusinessEditClubScreen";
  static const String businessAnalyticsScreen = "/BusinessAnalyticsScreen";
  static const String businessAccountSettingsScreen =
      "/BusinessAccountSettingsScreen";
  static const String businessSelectPlanScreen = "/BusinessSelectPlanScreen";
  static const String businessPromotionHubScreen =
      "/BusinessPromotionHubScreen";
  static const String businessCreatePromotionScreen =
      "/BusinessCreatePromotionScreen";

  static const String reelsScreen = "/ReelsScreen";
  static const String createReelScreen = "/CreateReelScreen";
  static const String clubDetaislScreenNonMy = "/ClubDetaislScreenNonMy";
  static const String clubMembersScreen = "/ClubMembersScreen";
  static const String clubJoinRequestsScreen = "/ClubJoinRequestsScreen";
  static const String clubGroupPostScreen = "/ClubGroupPostScreen";
  static const String mySessionsScreen = "/MySessionsScreen";
  static const String savedReelsScreen = "/SavedReelsScreen";

  static List<GetPage> routes = [
    ///===========================Authentication==========================
    GetPage(name: splashScreen, page: () => const SplashScreen()),

    ///============== User part ==================
    GetPage(
      name: onboardingScreen,
      page: () => OnboardingScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => OnboardingController(), fenix: true);
      }),
    ),
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
    GetPage(
      name: inboxScreen,
      page: () => InboxScreen(
        userName: Get.arguments?["userName"] ?? "Driver",
        avatarUrl:
            Get.arguments?["avatarUrl"] ?? "https://picsum.photos/100/100",
        isOnline: Get.arguments?["isOnline"] ?? false,
        userId: Get.arguments?["userId"],
      ),
    ),
    GetPage(name: supportMemberScreen, page: () => const SupportMemberScreen()),
    GetPage(name: eventDetailScreen, page: () => const EventDetailScreen()),
    GetPage(name: accessGrantedScreen, page: () => const AccessGrantedScreen()),
    GetPage(name: createClubScreen, page: () => const CreateClubScreen()),
    GetPage(name: editClubScreen, page: () => const EditClubScreen()),
    GetPage(name: discoverScreen, page: () => DiscoverScreen()),
    GetPage(name: addSpotScreen, page: () => const AddSpotScreen()),
    GetPage(name: editSpotScreen, page: () => const EditSpotScreen()),
    GetPage(name: addVideoScreen, page: () => const AddVideoScreen()),
    GetPage(name: createEventScreen, page: () => const CreateEventScreen()),
    GetPage(name: trackHubScreen, page: () => TrackHubScreen()),
    GetPage(name: prepareSessionScreen, page: () => PrepareSessionScreen()),
    GetPage(name: liveSessionScreen, page: () => const LiveSessionScreen()),
    GetPage(name: driveSummaryScreen, page: () => const DriveSummaryScreen()),
    GetPage(name: findTrackScreen, page: () => FindTrackScreen()),
    GetPage(name: trackDetailsScreen, page: () => const TrackDetailsScreen()),
    GetPage(name: groupDrivesScreen, page: () => const GroupDrivesScreen()),
    GetPage(name: tripConfiguratorScreen, page: () => TripConfiguratorScreen()),
    GetPage(name: tripLobbyScreen, page: () => const TripLobbyScreen()),
    GetPage(name: activeDriveScreen, page: () => const ActiveDriveScreen()),
    GetPage(name: endExpeditionScreen, page: () => const EndExpeditionScreen()),
    GetPage(
      name: shareExpeditionScreen,
      page: () => const ShareExpeditionScreen(),
    ),
    GetPage(name: clubDetailsScreen, page: () => const ClubDetailsScreen()),
    GetPage(name: createPostScreen, page: () => CreatePostScreen()),
    GetPage(name: clubPostScreen, page: () => const ClubPostScreen()),
    GetPage(
      name: marketplaceFeedScreen,
      page: () => const MarketplaceListingFeedScreen(),
    ),
    GetPage(name: itemDetailScreen, page: () => const ItemDetailScreen()),
    GetPage(
      name: selectCategoryScreen,
      page: () => const SelectCategoryScreen(),
    ),
    GetPage(
      name: createVehicleListingScreen,
      page: () => const CreateVehicleListingScreen(),
    ),
    GetPage(
      name: createMotorcycleListingScreen,
      page: () => const CreateMotorcycleListingScreen(),
    ),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: singleProfileScreen, page: () => const SingleProfileScreen()),
    GetPage(name: walletScreen, page: () => const WalletScreen()),
    GetPage(name: buyCoinsScreen, page: () => const BuyCoinsScreen()),
    GetPage(
      name: transactionReportScreen,
      page: () => const TransactionReportScreen(),
    ),
    GetPage(name: supportSentScreen, page: () => const SupportSentScreen()),
    GetPage(
      name: transactionHistoryScreen,
      page: () => const TransactionHistoryScreen(),
    ),
    GetPage(
      name: transactionVerificationScreen,
      page: () => const TransactionVerificationScreen(),
    ),
    GetPage(
      name: supportSuccessScreen,
      page: () => const SupportSuccessScreen(),
    ),
    GetPage(name: addVehicleScreen, page: () => const AddVehicleScreen()),
    GetPage(name: editProfileScreen, page: () => const EditProfileScreen()),
    GetPage(
      name: userParametersScreen,
      page: () => const UserParametersScreen(),
    ),
    GetPage(name: myListingsScreen, page: () => const MyListingsScreen()),
    GetPage(name: editVehicleScreen, page: () => const EditVehicleScreen()),
    GetPage(
      name: changePasswordScreen,
      page: () => const ChangePasswordScreen(),
    ),
    GetPage(name: termsScreen, page: () => const TermsScreen()),
    GetPage(name: privacyScreen, page: () => const PrivacyScreen()),
    GetPage(name: helpSupportScreen, page: () => const HelpSupportScreen()),
    GetPage(name: aboutScreen, page: () => const AboutScreen()),
    GetPage(
      name: personalizeInterestScreen,
      page: () => const PersonalizeInterestScreen(),
    ),
    GetPage(
      name: businessRegistrationStep1,
      page: () => const BusinessRegistrationStep1(),
    ),
    GetPage(
      name: businessRegistrationStep2,
      page: () => const BusinessRegistrationStep2(),
    ),
    GetPage(
      name: businessRegistrationStep3,
      page: () => const BusinessRegistrationStep3(),
    ),
    GetPage(
      name: businessRegistrationStep4,
      page: () => const BusinessRegistrationStep4(),
    ),
    GetPage(
      name: businessMyEventScreen,
      page: () => const BusinessMyEventScreen(),
    ),
    GetPage(name: businessHomeScreen, page: () => const BusinessHomeScreen()),
    GetPage(
      name: businessSocialHubScreen,
      page: () => const UserHomeScreen(isBusiness: true),
    ),
    GetPage(
      name: businessMarketplaceScreen,
      page: () => const MarketplaceListingFeedScreen(isBusiness: true),
    ),
    GetPage(name: businessClubsScreen, page: () => const BusinessClubsScreen()),
    GetPage(
      name: businessProfileScreen,
      page: () => const BusinessProfileScreen(),
    ),
    GetPage(
      name: businessAnalyticsScreen,
      page: () => const BusinessAnalyticsScreen(),
    ),
    GetPage(
      name: businessAccountSettingsScreen,
      page: () => const BusinessAccountSettingsScreen(),
    ),
    GetPage(
      name: businessSelectPlanScreen,
      page: () => const BusinessSelectPlanScreen(),
    ),
    GetPage(
      name: businessPromotionHubScreen,
      page: () => const BusinessPromotionHubScreen(),
    ),
    GetPage(
      name: businessCreatePromotionScreen,
      page: () => const BusinessCreatePromotionScreen(),
    ),
    GetPage(name: reelsScreen, page: () => const ReelsScreen()),
    GetPage(name: createReelScreen, page: () => const CreateReelScreen()),
    GetPage(
      name: clubDetaislScreenNonMy,
      page: () => const ClubDetaislScreenNonMy(),
    ),
    GetPage(name: clubMembersScreen, page: () => const ClubMembersScreen()),
    GetPage(
      name: clubJoinRequestsScreen,
      page: () => const ClubJoinRequestsScreen(),
    ),
    GetPage(name: clubGroupPostScreen, page: () => const ClubGroupPostScreen()),
    GetPage(
      name: mySessionsScreen,
      page: () => const speedring_my_sessions.MySessionsScreen(),
    ),
    GetPage(name: savedReelsScreen, page: () => const SavedReelsScreen()),
  ];
}
