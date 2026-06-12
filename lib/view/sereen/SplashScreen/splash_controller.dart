import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/app_routes/app_routes.dart';

class SplashController extends GetxController
    with GetTickerProviderStateMixin {
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
    'INITIALIZING TELEMETRY',
    'CONNECTING TO NETWORK',
    'LOADING DATA',
    'READY TO RACE',
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

    progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: progressController,
        curve: Curves.easeInOut,
      ),
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
    Future.delayed(const Duration(milliseconds: 4000), () {
      // TODO: SharedPreferences দিয়ে login check করুন
      // final isLoggedIn = Get.find<AuthService>().isLoggedIn;
      // Get.offAllNamed(isLoggedIn ? AppRoutes.homeScreen : AppRoutes.onboardingScreen);
      Get.offAllNamed(AppRoutes.onboardingScreen);
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
