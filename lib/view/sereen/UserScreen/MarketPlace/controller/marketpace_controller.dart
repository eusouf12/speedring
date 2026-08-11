import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import '../model/listing_model.dart';
import '../model/item_detail_model.dart';

class MarketplaceFeedController extends GetxController {
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

  // ===============================get All Listing============================================

  final ScrollController scrollController = ScrollController();
  final RxBool isHeaderButtonHidden = false.obs;
  var isLoadingFeed = false.obs;
  var isMoreLoadingFeed = false.obs;
  int _page = 1;
  int _totalPages = 1;
  var listings = <MarketplaceListing>[].obs;
  final TextEditingController searchController = TextEditingController();
  var searchQuery = "".obs;

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
        ApiUrl.getAllMarketplaceListings(
          page: _page,
          searchTerm: searchQuery.value,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body is String
            ? jsonDecode(response.body)
            : response.body;

        final listingResponse = MarketplaceListingResponse.fromJson(data);
        _totalPages = listingResponse.meta?.totalPage ?? 1;

        if (_page == 1) listings.clear();

        if (listingResponse.data != null) {
          listings.addAll(listingResponse.data!);
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

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    debounce(
      searchQuery,
      (_) => fetchListings(refresh: true),
      time: const Duration(milliseconds: 500),
    );
    fetchListings();
  }

  // ==============================CREATE LISTING SECTION=============================================

  var isCreating = false.obs;
  var isEditing = false.obs;
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

  // Performance Parts
  final partNameController = TextEditingController();
  final categoryController = TextEditingController();
  final compatibilityController = TextEditingController();
  final conditionController = TextEditingController();
  final weightReductionKgController = TextEditingController();
  final performanceGainController = TextEditingController();
  final materialController = TextEditingController();
  final partNumberController = TextEditingController();
  final shippingStrategyController = TextEditingController();

  // Expert Services
  final listingTitleController = TextEditingController();
  final providerNameController = TextEditingController();
  final hourlyRateUsdController = TextEditingController();
  final locationTypeController = TextEditingController();
  final trackSpecializationsController = TextEditingController();
  final experienceYearsController = TextEditingController();

  var selectedImages = <XFile>[].obs;
  final ImagePicker _picker = ImagePicker();

  void prepareEdit(ItemDetailModel item) {
    askingPriceController.text = item.askingPrice?.toString() ?? '';
    locationController.text = item.location ?? '';
    descriptionController.text = item.description ?? '';
    brandController.text = item.brand ?? '';
    modelDesignationController.text = item.modelDesignation ?? '';
    productionYearController.text = item.productionYear?.toString() ?? '';
    powerHpController.text = item.powerHP?.toString() ?? '';
    zeroToHundredController.text = item.zeroToHundred?.toString() ?? '';
    topSpeedController.text = item.topSpeed?.toString() ?? '';
    weightKgController.text = item.weightKG?.toString() ?? '';
    mileageKmController.text = item.mileageKM?.toString() ?? '';
    engineConfigurationController.text = item.engineConfiguration ?? '';
    transmissionController.text = item.transmission ?? '';
    drivetrainController.text = item.drivetrain ?? '';
    aerodynamicsBodyController.text = item.aerodynamicsBody ?? '';
    torqueNmController.text = item.torqueNM?.toString() ?? '';
    engineTypeController.text = item.engineType ?? '';
    displacementCcController.text = item.displacementCC?.toString() ?? '';
    suspensionController.text = item.suspension ?? '';
    brakingSystemController.text = item.brakingSystem ?? '';

    // Performance Parts
    partNameController.text = item.partName ?? '';
    categoryController.text = item.category ?? '';
    compatibilityController.text = item.compatibility ?? '';
    conditionController.text = item.condition ?? '';
    weightReductionKgController.text = item.weightReductionKG?.toString() ?? '';
    performanceGainController.text = item.performanceGain ?? '';
    materialController.text = item.material ?? '';
    partNumberController.text = item.partNumber ?? '';
    shippingStrategyController.text = item.shippingStrategy ?? '';

    // Expert Services
    listingTitleController.text = item.listingTitle ?? '';
    providerNameController.text = item.providerName ?? '';
    hourlyRateUsdController.text = item.hourlyRateUSD?.toString() ?? '';
    locationTypeController.text = item.locationType ?? '';
    trackSpecializationsController.text =
        item.trackSpecializations?.join(', ') ?? '';
    experienceYearsController.text = item.experienceYears?.toString() ?? '';

    selectedImages
        .clear(); // Cannot easily prepopulate network images as XFile without downloading
  }

  Future<void> editListing(String id, String itemType) async {
    if (askingPriceController.text.isEmpty ||
        locationController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        brandController.text.isEmpty ||
        modelDesignationController.text.isEmpty ||
        productionYearController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all required fields",
        colorText: Colors.white,
      );
      return;
    }

    isEditing.value = true;
    try {
      Map<String, String> body = {
        "itemType": itemType,
        "askingPrice": askingPriceController.text,
        "location": locationController.text,
        "description": descriptionController.text,
        "brand": brandController.text,
        "modelDesignation": modelDesignationController.text,
        "productionYear": productionYearController.text,
      };

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
        body["weightKG"] = weightKgController.text;
      }
      if (mileageKmController.text.isNotEmpty) {
        body["mileageKM"] = mileageKmController.text;
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
      if (torqueNmController.text.isNotEmpty) {
        body["torqueNm"] = torqueNmController.text;
      }
      if (engineTypeController.text.isNotEmpty) {
        body["engineType"] = engineTypeController.text;
      }
      if (displacementCcController.text.isNotEmpty) {
        body["displacementCc"] = displacementCcController.text;
      }
      if (suspensionController.text.isNotEmpty) {
        body["suspension"] = suspensionController.text;
      }
      if (brakingSystemController.text.isNotEmpty) {
        body["brakingSystem"] = brakingSystemController.text;
      }

      List<MultipartBody> multipartImages = selectedImages.map((image) {
        return MultipartBody('visualAssets', File(image.path));
      }).toList();

      final response = await ApiClient.patchMultipartData(
        ApiUrl.editListing(id),
        body,
        multipartBody: multipartImages,
      );

      if (response.statusCode == 200) {
        Get.back(); // close edit screen
        fetchListingDetails(id); // Refresh detail screen
        fetchListings(refresh: true); // Refresh feed
        Get.snackbar(
          "Success",
          "Listing updated successfully",
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to update listing",
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Error updating listing", colorText: Colors.white);
    } finally {
      isEditing.value = false;
    }
  }

  Future<void> createListing(String itemType) async {
    // Base required fields
    if (askingPriceController.text.isEmpty ||
        locationController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      showCustomSnackBar(
        "Error, Please fill base required fields",
        isError: true,
      );
      return;
    }

    if (itemType == "VEHICLES" || itemType == "MOTORCYCLES") {
      if (brandController.text.isEmpty ||
          modelDesignationController.text.isEmpty ||
          productionYearController.text.isEmpty) {
        showCustomSnackBar(
          "Error, Please fill vehicle required fields",
          isError: true,
        );
        return;
      }
    } else if (itemType == "PERFORMANCE_PARTS") {
      if (partNameController.text.isEmpty ||
          categoryController.text.isEmpty ||
          brandController.text.isEmpty) {
        showCustomSnackBar(
          "Error, Please fill part required fields",
          isError: true,
        );
        return;
      }
    } else if (itemType == "EXPERT_SERVICES") {
      if (listingTitleController.text.isEmpty ||
          categoryController.text.isEmpty ||
          providerNameController.text.isEmpty) {
        showCustomSnackBar(
          "Error, Please fill service required fields",
          isError: true,
        );
        return;
      }
    }

    if (selectedImages.isEmpty) {
      showCustomSnackBar("Error, Please add at least one image", isError: true);
      return;
    }

    isCreating.value = true;
    try {
      final Map<String, dynamic> body = {
        "itemType": itemType,
        "askingPrice": double.tryParse(askingPriceController.text) ?? 0,
        "location": locationController.text,
        "description": descriptionController.text,
      };

      if (itemType == "VEHICLES" || itemType == "MOTORCYCLES") {
        body["brand"] = brandController.text;
        body["modelDesignation"] = modelDesignationController.text;
        body["productionYear"] =
            int.tryParse(productionYearController.text) ?? DateTime.now().year;

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
      } else if (itemType == "PERFORMANCE_PARTS") {
        body["partName"] = partNameController.text;
        body["category"] = categoryController.text;
        body["brand"] = brandController.text;
        if (compatibilityController.text.isNotEmpty) {
          body["compatibility"] = compatibilityController.text;
        }
        if (conditionController.text.isNotEmpty) {
          body["condition"] = conditionController.text;
        }
        if (weightReductionKgController.text.isNotEmpty) {
          body["weightReductionKG"] = int.tryParse(
            weightReductionKgController.text,
          );
        }
        if (performanceGainController.text.isNotEmpty) {
          body["performanceGain"] = performanceGainController.text;
        }
        if (materialController.text.isNotEmpty) {
          body["material"] = materialController.text;
        }
        if (partNumberController.text.isNotEmpty) {
          body["partNumber"] = partNumberController.text;
        }
        if (shippingStrategyController.text.isNotEmpty) {
          body["shippingStrategy"] = shippingStrategyController.text;
        }
      } else if (itemType == "EXPERT_SERVICES") {
        body["listingTitle"] = listingTitleController.text;
        body["category"] = categoryController.text;
        body["providerName"] = providerNameController.text;
        if (hourlyRateUsdController.text.isNotEmpty) {
          body["hourlyRateUSD"] = int.tryParse(hourlyRateUsdController.text);
        }
        if (locationTypeController.text.isNotEmpty) {
          body["locationType"] = locationTypeController.text;
        }
        if (trackSpecializationsController.text.isNotEmpty) {
          body["trackSpecializations"] = trackSpecializationsController.text
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
        }
        if (experienceYearsController.text.isNotEmpty) {
          body["experienceYears"] = int.tryParse(
            experienceYearsController.text,
          );
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
        showCustomSnackBar("Listing created successfully!", isError: false);
        clearCreateForm();
        fetchListings(refresh: true); // Refresh feed
        Get.close(2);
      } else {
        showCustomSnackBar("Error, Failed to create listing", isError: true);
      }
    } catch (e) {
      showCustomSnackBar("Error: $e", isError: true);
    } finally {
      isCreating.value = false;
    }
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

    // Performance Parts
    partNameController.clear();
    categoryController.clear();
    compatibilityController.clear();
    conditionController.clear();
    weightReductionKgController.clear();
    performanceGainController.clear();
    materialController.clear();
    partNumberController.clear();
    shippingStrategyController.clear();

    // Expert Services
    listingTitleController.clear();
    providerNameController.clear();
    hourlyRateUsdController.clear();
    locationTypeController.clear();
    trackSpecializationsController.clear();
    experienceYearsController.clear();

    selectedImages.clear();
  }

  // ===========================================================================
  // 3. MY LISTINGS SECTION
  // ===========================================================================
  var isLoadingMyListings = false.obs;
  var isDeleting = false.obs;
  var myListings = <Map<String, dynamic>>[].obs;
  var currentPageMyListings = 1.obs;
  var hasMoreDataMyListings = true.obs;
  var currentCategoryMyListings = "ALL".obs;

  // =============================MyListing==============================================

  var isLoadingDetail = false.obs;
  var itemDetail = Rxn<ItemDetailModel>();
  var isFollowing = false.obs;

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
        Get.back(); // Pop the detail screen
        showCustomSnackBar(
          "Success ,Listing deleted successfully",
          isError: false,
        );
      } else {
        showCustomSnackBar("Failed to delete listing", isError: true);
      }
    } catch (e) {
      showCustomSnackBar("Error deleting listing: $e", isError: true);
    } finally {
      isDeleting.value = false;
    }
  }

  // ================================Follow user===========================================

  Future<void> toggleFollow() async {
    final userId = itemDetail.value?.seller?.id;
    if (userId == null) {
      showCustomSnackBar("Seller information not found", isError: true);
      return;
    }

    // Optimistic update
    isFollowing.value = !isFollowing.value;

    try {
      final response = await ApiClient.patchData(
        ApiUrl.toggleFollow(userId: userId),
        jsonEncode({}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        // Revert on failure
        isFollowing.value = !isFollowing.value;
        showCustomSnackBar(
          response.body['error'] ?? "Failed to toggle follow status",
          isError: true,
        );
      }
    } catch (e) {
      // Revert on error
      isFollowing.value = !isFollowing.value;
      showCustomSnackBar("Error: $e", isError: true);
    }
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
          final parsed = ItemDetailModel.fromJson(responseData['data']);
          itemDetail.value = parsed;
        }
      } else {
        itemDetail.value = null;
      }
    } catch (e) {
      itemDetail.value = null;
    } finally {
      isLoadingDetail.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    searchController.dispose();
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
    partNameController.dispose();
    categoryController.dispose();
    compatibilityController.dispose();
    conditionController.dispose();
    weightReductionKgController.dispose();
    performanceGainController.dispose();
    materialController.dispose();
    partNumberController.dispose();
    shippingStrategyController.dispose();
    listingTitleController.dispose();
    providerNameController.dispose();
    hourlyRateUsdController.dispose();
    locationTypeController.dispose();
    trackSpecializationsController.dispose();
    experienceYearsController.dispose();

    super.onClose();
  }
}
