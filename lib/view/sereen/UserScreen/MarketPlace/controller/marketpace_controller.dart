import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';

class MarketplaceFeedController extends GetxController {
  // ===========================================================================
  // 1. FEED SECTION
  // ===========================================================================
  final ScrollController scrollController = ScrollController();
  final RxBool isHeaderButtonHidden = false.obs;
  var isLoadingFeed = false.obs;
  var isMoreLoadingFeed = false.obs;
  int _page = 1;
  int _totalPages = 1;
  final RxList<Map<String, dynamic>> listings = <Map<String, dynamic>>[].obs;

  // ===========================================================================
  // 2. CREATE LISTING SECTION
  // ===========================================================================
  var isCreating = false.obs;
  final askingPriceController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  final brandController = TextEditingController();
  final modelDesignationController = TextEditingController();
  final productionYearController = TextEditingController();
  final powerHpController = TextEditingController();
  final zeroToHundredController = TextEditingController();
  final topSpeedController = TextEditingController();
  final weightKgController = TextEditingController();
  final mileageKmController = TextEditingController();
  final engineConfigurationController = TextEditingController();
  final transmissionController = TextEditingController();
  final drivetrainController = TextEditingController();
  final aerodynamicsBodyController = TextEditingController();
  final torqueNmController = TextEditingController();
  final engineTypeController = TextEditingController();
  final displacementCcController = TextEditingController();
  final suspensionController = TextEditingController();
  final brakingSystemController = TextEditingController();
  var selectedImages = <XFile>[].obs;
  final ImagePicker _picker = ImagePicker();

  // ===========================================================================
  // 3. MY LISTINGS SECTION
  // ===========================================================================
  var isLoadingMyListings = false.obs;
  var isDeleting = false.obs;
  var myListings = <Map<String, dynamic>>[].obs;
  var currentPageMyListings = 1.obs;
  var hasMoreDataMyListings = true.obs;
  var currentCategoryMyListings = "ALL".obs;

  // ===========================================================================
  // 4. ITEM DETAIL SECTION
  // ===========================================================================
  var isLoadingDetail = false.obs;
  var listingData = <String, dynamic>{}.obs;
  var isFollowing = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    fetchListings();
  }

  // ===========================================================================
  // FEED METHODS
  // ===========================================================================
  Future<void> fetchListings({bool refresh = false}) async {
    if (isLoadingFeed.value || isMoreLoadingFeed.value) return;

    if (refresh) {
      _page = 1;
      _totalPages = 1;
    }
    if (_page > _totalPages) return;

    _page == 1 ? isLoadingFeed.value = true : isMoreLoadingFeed.value = true;

    try {
      final response = await ApiClient.getData(
        ApiUrl.getAllMarketplaceListings(page: _page),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        final resData = data['data'] as List?;
        final meta = data['meta'];
        _totalPages = meta?['totalPage'] ?? 1;

        if (_page == 1) listings.clear();

        if (resData != null) {
          listings.addAll(
            resData.map((e) => e as Map<String, dynamic>).toList(),
          );
        }
        _page++;
      }
    } catch (e) {
      debugPrint("Error fetching marketplace listings: $e");
    } finally {
      isLoadingFeed.value = false;
      isMoreLoadingFeed.value = false;
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      fetchListings();
    }
    if (scrollController.offset > 0) {
      if (!isHeaderButtonHidden.value) isHeaderButtonHidden.value = true;
    } else {
      if (isHeaderButtonHidden.value) isHeaderButtonHidden.value = false;
    }
  }

  // ===========================================================================
  // CREATE LISTING METHODS
  // ===========================================================================
  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        selectedImages.addAll(images);
      }
    } catch (e) {
      // showCustomSnackBar("Failed to pick images", isError: true);
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  void clearCreateForm() {
    askingPriceController.clear();
    locationController.clear();
    descriptionController.clear();
    brandController.clear();
    modelDesignationController.clear();
    productionYearController.clear();
    powerHpController.clear();
    zeroToHundredController.clear();
    topSpeedController.clear();
    weightKgController.clear();
    mileageKmController.clear();
    engineConfigurationController.clear();
    transmissionController.clear();
    drivetrainController.clear();
    aerodynamicsBodyController.clear();
    torqueNmController.clear();
    engineTypeController.clear();
    displacementCcController.clear();
    suspensionController.clear();
    brakingSystemController.clear();
    selectedImages.clear();
  }

  Future<void> createListing(String itemType) async {
    if (askingPriceController.text.isEmpty ||
        locationController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        brandController.text.isEmpty ||
        modelDesignationController.text.isEmpty ||
        productionYearController.text.isEmpty) {
      // showCustomSnackBar("Please fill all required fields", isError: true);
      return;
    }

    if (selectedImages.isEmpty) {
      // showCustomSnackBar("Please add at least one image", isError: true);
      return;
    }

    isCreating.value = true;
    try {
      final Map<String, dynamic> body = {
        "itemType": itemType,
        "askingPrice": double.tryParse(askingPriceController.text) ?? 0,
        "location": locationController.text,
        "description": descriptionController.text,
        "brand": brandController.text,
        "modelDesignation": modelDesignationController.text,
        "productionYear":
            int.tryParse(productionYearController.text) ?? DateTime.now().year,
      };

      if (itemType == "VEHICLES") {
        if (powerHpController.text.isNotEmpty) {
          body["powerHP"] = powerHpController.text;
        }
        if (zeroToHundredController.text.isNotEmpty) {
          body["zeroToHundred"] = zeroToHundredController.text;
        }
        if (topSpeedController.text.isNotEmpty) {
          body["topSpeed"] = topSpeedController.text;
        }
        if (weightKgController.text.isNotEmpty) {
          body["weightKG"] = int.tryParse(weightKgController.text);
        }
        if (mileageKmController.text.isNotEmpty) {
          body["mileageKM"] = int.tryParse(mileageKmController.text);
        }
        if (engineConfigurationController.text.isNotEmpty) {
          body["engineConfiguration"] = engineConfigurationController.text;
        }
        if (transmissionController.text.isNotEmpty) {
          body["transmission"] = transmissionController.text;
        }
        if (drivetrainController.text.isNotEmpty) {
          body["drivetrain"] = drivetrainController.text;
        }
        if (aerodynamicsBodyController.text.isNotEmpty) {
          body["aerodynamicsBody"] = aerodynamicsBodyController.text;
        }
      } else if (itemType == "MOTORCYCLES") {
        if (engineTypeController.text.isNotEmpty) {
          body["engineType"] = engineTypeController.text;
        }
        if (powerHpController.text.isNotEmpty) {
          body["powerHP"] = powerHpController.text;
        }
        if (torqueNmController.text.isNotEmpty) {
          body["torqueNM"] = torqueNmController.text;
        }
        if (weightKgController.text.isNotEmpty) {
          body["weightKG"] = int.tryParse(weightKgController.text);
        }
        if (zeroToHundredController.text.isNotEmpty) {
          body["zeroToHundred"] = zeroToHundredController.text;
        }
        if (displacementCcController.text.isNotEmpty) {
          body["displacementCC"] = displacementCcController.text;
        }
        if (transmissionController.text.isNotEmpty) {
          body["transmission"] = transmissionController.text;
        }
        if (suspensionController.text.isNotEmpty) {
          body["suspension"] = suspensionController.text;
        }
        if (brakingSystemController.text.isNotEmpty) {
          body["brakingSystem"] = brakingSystemController.text;
        }
      }

      final List<MultipartBody> multipartFiles = selectedImages
          .map((img) => MultipartBody('visualAssets', File(img.path)))
          .toList();

      final response = await ApiClient.postMultipartData(
        ApiUrl.createMarketplaceListing,
        {'data': jsonEncode(body)},
        multipartBody: multipartFiles,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // showCustomSnackBar("Listing created successfully!", isError: false);
        clearCreateForm();
        fetchListings(refresh: true); // Refresh feed
        Get.back();
      } else {
        // Map<String, dynamic> jsonResponse = {};
        // try {
        //   jsonResponse = response.body is String
        //       ? jsonDecode(response.body)
        //       : response.body;
        // } catch (_) {}
        // showCustomSnackBar(
        //   jsonResponse['message'] ?? "Failed to create listing",
        //   isError: true,
        // );
      }
    } catch (e) {
      // showCustomSnackBar("Error: $e", isError: true);
    } finally {
      isCreating.value = false;
    }
  }

  // ===========================================================================
  // MY LISTINGS METHODS
  // ===========================================================================
  Future<void> fetchMyListings({bool isRefresh = false}) async {
    if (isLoadingMyListings.value) return;

    if (isRefresh) {
      currentPageMyListings.value = 1;
      hasMoreDataMyListings.value = true;
      myListings.clear();
    }

    if (!hasMoreDataMyListings.value) return;

    isLoadingMyListings.value = true;

    try {
      final String url = ApiUrl.getMyListings(
        page: currentPageMyListings.value,
        category: currentCategoryMyListings.value,
      );

      final response = await ApiClient.getData(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = {};
        if (response.body is String) {
          responseData = jsonDecode(response.body);
        } else {
          responseData = response.body;
        }

        if (responseData['success'] == true) {
          List<dynamic> rawData = responseData['data'] ?? [];
          if (rawData.isEmpty) {
            hasMoreDataMyListings.value = false;
          } else {
            List<Map<String, dynamic>> mappedList = rawData
                .map((e) => e as Map<String, dynamic>)
                .toList();
            myListings.addAll(mappedList);
            currentPageMyListings.value++;
          }
        }
      } else {
        // showCustomSnackBar("Failed to load listings.", isError: true);
      }
    } catch (e) {
      // showCustomSnackBar("Error fetching listings: $e", isError: true);
    } finally {
      isLoadingMyListings.value = false;
    }
  }

  void changeCategory(String category) {
    if (currentCategoryMyListings.value == category) return;
    currentCategoryMyListings.value = category;
    fetchMyListings(isRefresh: true);
  }

  Future<void> deleteListing(String id) async {
    isDeleting.value = true;
    try {
      final response = await ApiClient.deleteData(ApiUrl.deleteListing(id));
      if (response.statusCode == 200) {
        myListings.removeWhere((item) => item['id'] == id);
        fetchListings(refresh: true); // Refresh feed to reflect deletion
        // showCustomSnackBar("Listing deleted successfully", isError: false);
      } else {
        // showCustomSnackBar("Failed to delete listing", isError: true);
      }
    } catch (e) {
      // showCustomSnackBar("Error deleting listing: $e", isError: true);
    } finally {
      isDeleting.value = false;
    }
  }

  // ===========================================================================
  // ITEM DETAIL METHODS
  // ===========================================================================
  void toggleFollow() {
    isFollowing.value = !isFollowing.value;
  }

  Future<void> fetchListingDetails(String id) async {
    isLoadingDetail.value = true;
    try {
      final response = await ApiClient.getData(ApiUrl.viewListing(id));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = {};
        if (response.body is String) {
          responseData = jsonDecode(response.body);
        } else {
          responseData = response.body;
        }

        if (responseData['success'] == true && responseData['data'] != null) {
          listingData.value = responseData['data'];
        }
      } else {
        // showCustomSnackBar("Failed to load listing details.", isError: true);
      }
    } catch (e) {
      // showCustomSnackBar("Error: $e", isError: true);
    } finally {
      isLoadingDetail.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    askingPriceController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    brandController.dispose();
    modelDesignationController.dispose();
    productionYearController.dispose();
    powerHpController.dispose();
    zeroToHundredController.dispose();
    topSpeedController.dispose();
    weightKgController.dispose();
    mileageKmController.dispose();
    engineConfigurationController.dispose();
    transmissionController.dispose();
    drivetrainController.dispose();
    aerodynamicsBodyController.dispose();
    torqueNmController.dispose();
    engineTypeController.dispose();
    displacementCcController.dispose();
    suspensionController.dispose();
    brakingSystemController.dispose();

    super.onClose();
  }
}
