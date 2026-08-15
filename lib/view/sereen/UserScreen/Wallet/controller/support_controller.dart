import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import '../model/coin_package_model.dart';
import 'dart:convert';

class SupportController extends GetxController {
  final selectedPackageIndex = 7.obs; // Default to some index if available
  final selectedPaymentMethod = 0.obs; // Default Stripe

  RxList<CoinPackage> packages = <CoinPackage>[].obs;
  RxBool isLoadingPackages = false.obs;
  RxBool isCreatingCheckout = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActivePackages();
  }

  Future<void> fetchActivePackages() async {
    isLoadingPackages.value = true;
    try {
      var response = await ApiClient.getData(ApiUrl.getActiveCoinPackages);
      if (response.statusCode == 200) {
        CoinPackageResponse packageResponse = CoinPackageResponse.fromJson(response.body is String ? jsonDecode(response.body) : response.body);
        if (packageResponse.data != null) {
          packages.assignAll(packageResponse.data!);
          // Ensure selected index is within bounds
          if (packages.isNotEmpty && selectedPackageIndex.value >= packages.length) {
            selectedPackageIndex.value = packages.length - 1;
          } else if (packages.isNotEmpty && packages.length > 7) {
            selectedPackageIndex.value = 7;
          } else {
            selectedPackageIndex.value = 0;
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching coin packages: $e");
    } finally {
      isLoadingPackages.value = false;
    }
  }

  Future<String?> buyPackage(String packageId) async {
    isCreatingCheckout.value = true;
    try {
      var response = await ApiClient.postData(
        ApiUrl.buyCoinPackage(packageId),
        jsonEncode({}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.body is String ? jsonDecode(response.body) : response.body;
        if (resData['data'] != null && resData['data']['url'] != null) {
          return resData['data']['url'];
        }
      }
      showCustomSnackBar("error".tr, isError: true);
      return null;
    } catch (e) {
      debugPrint("Checkout Error: $e");
      showCustomSnackBar("error".tr, isError: true);
      return null;
    } finally {
      isCreatingCheckout.value = false;
    }
  }

  double get subtotal {
    if (packages.isEmpty) return 0.0;
    int idx = selectedPackageIndex.value;
    if (idx >= packages.length) idx = 0;
    return packages[idx].price?.toDouble() ?? 0.0;
  }

  String get selectedItemLabel {
    if (packages.isEmpty) return "";
    int idx = selectedPackageIndex.value;
    if (idx >= packages.length) idx = 0;
    return "${packages[idx].name} (${packages[idx].coinsAmount} COINS)";
  }

  double get processingFee => 0.00;

  double get totalAmount => subtotal + processingFee;
}
