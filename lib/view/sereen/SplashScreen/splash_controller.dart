import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../helper/shared_prefe/shared_prefe.dart';
import '../../../utils/app_const/app_const.dart';
import '../../../helper/guest_checker.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  // ── Observable state ──
  final RxDouble progress = 0.0.obs;
  final RxInt statusIndex = 0.obs;

  // ── Animation controllers ──
  late AnimationController progressController;
  late AnimationController logoController;
  late AnimationController dotsController;

  // ── Animations ──
  late Animation<double> logoFadeAnimation;
  late Animation<double> logoScaleAnimation;
  late Animation<double> progressAnimation;

  // ── Constants ──
  final List<String> statusMessages = const [
    'initializingTelemetry',
    'connectingToNetwork',
    'loadingData',
    'readyToRace',
  ];

  Timer? _statusTimer;

  @override
  void onInit() {
    super.onInit();
    _setStatusBar();
    _initAnimations();
    _startStatusCycle();
    _navigateAfterDelay();
  }

  void _setStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _initAnimations() {
    // ── Logo entrance ──
    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    logoScaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    logoController.forward();

    // ── Progress bar ──
    progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    progressAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: progressController, curve: Curves.easeInOut),
        )..addListener(() {
          progress.value = progressAnimation.value;
        });

    Future.delayed(const Duration(milliseconds: 600), () {
      progressController.forward();
    });

    // ── Dots pulse ──
    dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  void _startStatusCycle() {
    _statusTimer = Timer.periodic(const Duration(milliseconds: 900), (_) {
      statusIndex.value = (statusIndex.value + 1) % statusMessages.length;
    });
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(milliseconds: 4000), () async {
      if (!isClosed) {
        final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
        final isGuest = GuestChecker.isGuest;

        if (isGuest) {
          Get.offAllNamed(AppRoutes.userHomeScreen);
        } else if (token.isNotEmpty) {
          final role = await SharePrefsHelper.getString(AppConstants.role);
          if (role == 'business') {
            Get.offAllNamed(AppRoutes.businessHomeScreen);
          } else {
            Get.offAllNamed(AppRoutes.userHomeScreen);
          }
        } else {
          Get.offAllNamed(AppRoutes.onboardingScreen);
        }
      }
    });
  }

  @override
  void onClose() {
    progressController.dispose();
    logoController.dispose();
    dotsController.dispose();
    _statusTimer?.cancel();
    super.onClose();
  }
}
