import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';

class ManageWebController extends GetxController {
  final RxString termsContent = "".obs;
  final RxString privacyContent = "".obs;
  final RxString aboutUsContent = "".obs;
  final RxBool isLoadingTerms = false.obs;
  final RxBool isLoadingPrivacy = false.obs;
  final RxBool isLoadingAbout = false.obs;

  final RxList<Map<String, dynamic>> faqList = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingFaq = false.obs;

  Future<void> fetchTermsAndConditions() async {
    isLoadingTerms.value = true;
    try {
      var response = await ApiClient.getData(ApiUrl.getWebContent("terms-and-conditions"));
      if (response.statusCode == 200) {
        var body = response.body is String ? jsonDecode(response.body) : response.body;
        if (body['data'] != null && body['data']['description'] != null) {
          termsContent.value = body['data']['description'];
        }
      } else {
        showCustomSnackBar("Failed to load Terms & Conditions", isError: true);
      }
    } catch (e) {
      debugPrint("Error fetching terms: $e");
    } finally {
      isLoadingTerms.value = false;
    }
  }

  Future<void> fetchPrivacyPolicy() async {
    isLoadingPrivacy.value = true;
    try {
      var response = await ApiClient.getData(ApiUrl.getWebContent("privacy-policy"));
      if (response.statusCode == 200) {
        var body = response.body is String ? jsonDecode(response.body) : response.body;
        if (body['data'] != null && body['data']['description'] != null) {
          privacyContent.value = body['data']['description'];
        }
      } else {
        showCustomSnackBar("Failed to load Privacy Policy", isError: true);
      }
    } catch (e) {
      debugPrint("Error fetching privacy policy: $e");
    } finally {
      isLoadingPrivacy.value = false;
    }
  }

  Future<void> fetchAboutUs() async {
    isLoadingAbout.value = true;
    try {
      var response = await ApiClient.getData(ApiUrl.getWebContent("about-us"));
      if (response.statusCode == 200) {
        var body = response.body is String ? jsonDecode(response.body) : response.body;
        if (body['data'] != null && body['data']['description'] != null) {
          aboutUsContent.value = body['data']['description'];
        }
      } else {
        showCustomSnackBar("Failed to load About Us", isError: true);
      }
    } catch (e) {
      debugPrint("Error fetching about us: $e");
    } finally {
      isLoadingAbout.value = false;
    }
  }

  Future<void> fetchFaq() async {
    isLoadingFaq.value = true;
    try {
      var response = await ApiClient.getData(ApiUrl.getFaq);
      if (response.statusCode == 200) {
        var body = response.body is String ? jsonDecode(response.body) : response.body;
        if (body['data'] != null) {
          faqList.assignAll(List<Map<String, dynamic>>.from(body['data']));
        }
      } else {
        showCustomSnackBar("Failed to load FAQs", isError: true);
      }
    } catch (e) {
      debugPrint("Error fetching FAQ: $e");
    } finally {
      isLoadingFaq.value = false;
    }
  }
}
