import 'dart:async';
import 'dart:developer';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/sereen/UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';

/// Handles only link detection and navigation
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  /// Initialize deep links
  Future<void> initDeepLinks() async {
    // Cold start
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLink(initialLink);
    }

    // Foreground/background
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) => _handleLink(uri),
      onError: (err) => debugPrint("DeepLink error: $err"),
    );
  }

  void _handleLink(Uri uri) {
    log("Handling deep link: ${uri.toString()}");
    if (uri.path.startsWith("/post/")) {
      final postId = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
      if (postId != null) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          try {
            final homeController = Get.find<HomeController>();
            homeController.rxActiveTab.value = 0;
            homeController.getPost(searchTerm: postId);
          } catch (e) {
            log("Error finding HomeController on deep link navigation: $e");
          }
        });
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
