import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssetModel {
  String id;
  String title;
  String status; // LIVE, RESERVED, DRAFT, SOLD
  String code; // Chassis ID / VIN / Part Code
  String type; // VEHICLES, MOTORCYCLES, PARTS, SERVICES
  String price;
  String views;
  String leads;
  String shipping; // YES, NO
  String imageUrl;
  String description;
  String power;
  String torque;
  String zeroToSixty;
  String engineConfig;
  String transmission;
  String drivetrain; // RWD, AWD

  AssetModel({
    required this.id,
    required this.title,
    required this.status,
    required this.code,
    required this.type,
    required this.price,
    required this.views,
    required this.leads,
    required this.shipping,
    required this.imageUrl,
    required this.description,
    required this.power,
    required this.torque,
    required this.zeroToSixty,
    required this.engineConfig,
    required this.transmission,
    required this.drivetrain,
  });

  AssetModel copyWith({
    String? title,
    String? status,
    String? code,
    String? type,
    String? price,
    String? views,
    String? leads,
    String? shipping,
    String? imageUrl,
    String? description,
    String? power,
    String? torque,
    String? zeroToSixty,
    String? engineConfig,
    String? transmission,
    String? drivetrain,
  }) {
    return AssetModel(
      id: id,
      title: title ?? this.title,
      status: status ?? this.status,
      code: code ?? this.code,
      type: type ?? this.type,
      price: price ?? this.price,
      views: views ?? this.views,
      leads: leads ?? this.leads,
      shipping: shipping ?? this.shipping,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      power: power ?? this.power,
      torque: torque ?? this.torque,
      zeroToSixty: zeroToSixty ?? this.zeroToSixty,
      engineConfig: engineConfig ?? this.engineConfig,
      transmission: transmission ?? this.transmission,
      drivetrain: drivetrain ?? this.drivetrain,
    );
  }
}

class BusinessDashboardController extends GetxController {
  // Active tab in Inventory ("ALL", "VEHICLES", "MOTORCYCLES", "PARTS", "SERVICES")
  final rxActiveTab = "ALL".obs;

  // Selected asset for editing/managing
  final rxSelectedAsset = Rxn<AssetModel>();

  // Text Editing Controllers for Edit form
  late TextEditingController manufacturerController;
  late TextEditingController modelController;
  late TextEditingController productionYearController;
  late TextEditingController askingPriceController;
  late TextEditingController powerController;
  late TextEditingController torqueController;
  late TextEditingController zeroToSixtyController;
  late TextEditingController descriptionController;

  final selectedEngineConfig = "4.0L Flat-6".obs;
  final selectedTransmission = "7-Speed PDK".obs;
  final selectedDrivetrain = "RWD".obs; // RWD or AWD

  // Initial Assets Mock Data
  final rxAssets = <AssetModel>[
    AssetModel(
      id: "1",
      title: "2024 PORSCHE 911 GT3 RS",
      status: "LIVE",
      code: "992-GT3-2024-001",
      type: "VEHICLES",
      price: r"$289,500",
      views: "12,482",
      leads: "14",
      shipping: "YES",
      imageUrl:
          "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop",
      description:
          "High-performance track variant with Weissach package and carbon ceramic brakes.",
      power: "518 HP",
      torque: "465 NM",
      zeroToSixty: "3.0 SEC",
      engineConfig: "4.0L Flat-6",
      transmission: "7-Speed PDK",
      drivetrain: "RWD",
    ),
    AssetModel(
      id: "2",
      title: "2024 DUCATI PANIGALE V4 R",
      status: "RESERVED",
      code: "DUC-2024-PANV4-772",
      type: "MOTORCYCLES",
      price: r"$44,900",
      views: "8,114",
      leads: "2",
      shipping: "YES",
      imageUrl:
          "https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800&fit=crop",
      description:
          "Elite two-wheel performance machinery with carbon winglets and race exhaust.",
      power: "218 HP",
      torque: "112 NM",
      zeroToSixty: "2.7 SEC",
      engineConfig: "998cc V4",
      transmission: "6-Speed Quickshift",
      drivetrain: "RWD",
    ),
    AssetModel(
      id: "3",
      title: "ÖHLINS TTX FLOW REAR SHOCK",
      status: "DRAFT",
      code: "OH-TTX-FLOW-911",
      type: "PARTS",
      price: r"$1,450",
      views: "0",
      leads: "0",
      shipping: "NO",
      imageUrl:
          "https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=800&fit=crop",
      description:
          "Individual components and engineering modules. Custom tuned for track use.",
      power: "N/A",
      torque: "N/A",
      zeroToSixty: "N/A",
      engineConfig: "N/A",
      transmission: "N/A",
      drivetrain: "N/A",
    ),
  ].obs;

  @override
  void onInit() {
    manufacturerController = TextEditingController();
    modelController = TextEditingController();
    productionYearController = TextEditingController();
    askingPriceController = TextEditingController();
    powerController = TextEditingController();
    torqueController = TextEditingController();
    zeroToSixtyController = TextEditingController();
    descriptionController = TextEditingController();
    super.onInit();
  }

  // Pre-fill fields for editing
  void setAssetForEdit(AssetModel asset) {
    rxSelectedAsset.value = asset;

    // Split title "2024 PORSCHE 911 GT3 RS" into parts if needed, or prefill directly
    String manufacturer = "Porsche";
    String model = asset.title;
    if (asset.title.contains("PORSCHE")) {
      manufacturer = "Porsche";
      model = asset.title.replaceAll("2024 ", "").replaceAll("PORSCHE ", "");
    } else if (asset.title.contains("DUCATI")) {
      manufacturer = "Ducati";
      model = asset.title.replaceAll("2024 ", "").replaceAll("DUCATI ", "");
    } else if (asset.title.contains("ÖHLINS")) {
      manufacturer = "Öhlins";
      model = asset.title.replaceAll("ÖHLINS ", "");
    }

    manufacturerController.text = manufacturer;
    modelController.text = model;
    productionYearController.text = asset.title.startsWith("20")
        ? asset.title.substring(0, 4)
        : "2024";
    askingPriceController.text = asset.price
        .replaceAll(r"$", "")
        .replaceAll(",", "");
    powerController.text = asset.power;
    torqueController.text = asset.torque;
    zeroToSixtyController.text = asset.zeroToSixty;
    descriptionController.text = asset.description;

    selectedEngineConfig.value = asset.engineConfig;
    selectedTransmission.value = asset.transmission;
    selectedDrivetrain.value = asset.drivetrain;
  }

  // Save changes to current asset
  void saveAssetChanges() {
    final selected = rxSelectedAsset.value;
    if (selected != null) {
      final index = rxAssets.indexWhere((a) => a.id == selected.id);
      if (index != -1) {
        // Construct new title from year + manufacturer + model
        String year = productionYearController.text.trim();
        String mfg = manufacturerController.text.trim().toUpperCase();
        String mdl = modelController.text.trim().toUpperCase();
        String newTitle = "$year $mfg $mdl".trim();
        if (newTitle.startsWith(" ")) newTitle = newTitle.substring(1);

        // Parse price
        String cleanPrice = askingPriceController.text.trim();
        if (!cleanPrice.startsWith(r"$")) {
          // Format with comma if numeric
          double? p = double.tryParse(cleanPrice);
          if (p != null) {
            // simple formatter
            final formatted = p
                .toStringAsFixed(0)
                .replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
                );
            cleanPrice = r"$" + formatted;
          } else {
            cleanPrice = r"$" + cleanPrice;
          }
        }

        final updated = selected.copyWith(
          title: newTitle,
          price: cleanPrice,
          power: powerController.text.trim(),
          torque: torqueController.text.trim(),
          zeroToSixty: zeroToSixtyController.text.trim(),
          description: descriptionController.text.trim(),
          engineConfig: selectedEngineConfig.value,
          transmission: selectedTransmission.value,
          drivetrain: selectedDrivetrain.value,
        );

        rxAssets[index] = updated;
        rxSelectedAsset.value = updated;
      }
    }
  }

  // Mark asset as sold
  void markAsSold() {
    final selected = rxSelectedAsset.value;
    if (selected != null) {
      final index = rxAssets.indexWhere((a) => a.id == selected.id);
      if (index != -1) {
        final updated = selected.copyWith(status: "SOLD");
        rxAssets[index] = updated;
        rxSelectedAsset.value = updated;
      }
    }
  }

  // Add new asset (mock)
  void addNewMockAsset(String category) {
    String newId = (rxAssets.length + 1).toString();
    AssetModel newAsset;

    if (category == "VEHICLES") {
      newAsset = AssetModel(
        id: newId,
        title: "2025 FERRARI SF90 STRADALE",
        status: "LIVE",
        code: "FE-SF90-2025-099",
        type: "VEHICLES",
        price: r"$524,000",
        views: "150",
        leads: "1",
        shipping: "YES",
        imageUrl:
            "https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=800&fit=crop",
        description:
            "Hybrid supercar with extreme downforce and track pedigree.",
        power: "986 HP",
        torque: "800 NM",
        zeroToSixty: "2.5 SEC",
        engineConfig: "4.0L Twin-Turbo V8 Hybrid",
        transmission: "8-Speed Dual-Clutch",
        drivetrain: "AWD",
      );
    } else if (category == "MOTORCYCLES") {
      newAsset = AssetModel(
        id: newId,
        title: "2025 YAMAHA YZF-R1M",
        status: "LIVE",
        code: "YA-R1M-2025-010",
        type: "MOTORCYCLES",
        price: r"$27,800",
        views: "95",
        leads: "0",
        shipping: "YES",
        imageUrl:
            "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800&fit=crop",
        description:
            "Carbon fiber fairings, Öhlins electronic suspension, and MotoGP derived electronics.",
        power: "200 HP",
        torque: "113 NM",
        zeroToSixty: "2.9 SEC",
        engineConfig: "998cc inline-4",
        transmission: "6-speed",
        drivetrain: "RWD",
      );
    } else if (category == "PARTS") {
      newAsset = AssetModel(
        id: newId,
        title: "BREMBO GTR RACING CALIPERS",
        status: "LIVE",
        code: "BR-GTR-CAL-04",
        type: "PARTS",
        price: r"$8,500",
        views: "340",
        leads: "3",
        shipping: "YES",
        imageUrl:
            "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800&fit=crop",
        description:
            "Monoblock billet aluminum calipers optimized for track heat dissipation.",
        power: "N/A",
        torque: "N/A",
        zeroToSixty: "N/A",
        engineConfig: "N/A",
        transmission: "N/A",
        drivetrain: "N/A",
      );
    } else {
      newAsset = AssetModel(
        id: newId,
        title: "PRO COACHING & ECU CALIBRATION",
        status: "LIVE",
        code: "SR-SRV-COACH",
        type: "SERVICES",
        price: r"$1,200 / DAY",
        views: "48",
        leads: "2",
        shipping: "NO",
        imageUrl:
            "https://images.unsplash.com/photo-1517524206127-48bbd363f3d7?w=800&fit=crop",
        description:
            "1-on-1 track coaching with telemetry analysis and custom ECU tuning.",
        power: "N/A",
        torque: "N/A",
        zeroToSixty: "N/A",
        engineConfig: "N/A",
        transmission: "N/A",
        drivetrain: "N/A",
      );
    }

    rxAssets.insert(0, newAsset);
  }
}
