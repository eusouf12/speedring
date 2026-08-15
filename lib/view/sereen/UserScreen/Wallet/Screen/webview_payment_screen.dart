import 'package:flutter/material.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_colors/app_colors.dart';

class WebViewPaymentScreen extends StatefulWidget {
  const WebViewPaymentScreen({super.key});

  @override
  State<WebViewPaymentScreen> createState() => _WebViewPaymentScreenState();
}

class _WebViewPaymentScreenState extends State<WebViewPaymentScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final url = Get.arguments?['url'] as String? ?? 'https://google.com';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('/payment/success')) {
              Get.back();
              Get.snackbar(
                "success".tr,
                "paymentSuccess".tr,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
              return NavigationDecision.prevent;
            } else if (request.url.contains('/payment/cancel')) {
              Get.back();
              Get.snackbar(
                "cancelled".tr,
                "paymentCancelled".tr,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomRoyelAppbar(leftIcon: false),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.yellow),
              ),
          ],
        ),
      ),
    );
  }
}
