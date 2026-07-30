class PlanModel {
  final String id;
  final String rawName;
  final String name;
  final String tier;
  final String price;
  final List<String> features;
  final String? badge;
  final String? promoTag;
  final bool isProBadge;
  final bool isHighlighted;

  PlanModel({
    required this.id,
    required this.rawName,
    required this.name,
    required this.tier,
    required this.price,
    required this.features,
    this.badge,
    this.promoTag,
    this.isProBadge = false,
    this.isHighlighted = false,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    String nameRaw = json['name'] ?? '';

    // Map name to tier and display name
    String tier = '';
    String displayName = nameRaw;
    bool isPro = false;
    bool isHighlighted = false;
    String? badge;

    if (nameRaw == 'FREE') {
      tier = 'ENTRY LEVEL';
      displayName = 'FREE';
    } else if (nameRaw == 'PRO') {
      tier = 'PROFESSIONAL';
      displayName = 'PRO';
      isPro = true;
      isHighlighted = true;
      badge = 'MOST POPULAR';
    } else if (nameRaw.startsWith('BUSINESS')) {
      tier = 'CORPORATE';
      displayName = nameRaw.replaceAll('_', ' ');
    }

    // Format price
    int priceInt = json['price'] ?? 0;
    String currencyStr = json['currency'] == 'eur'
        ? '€'
        : (json['currency'] ?? '');
    String intervalStr = json['interval'] != null ? '/${json['interval']}' : '';

    String formattedPrice = '';
    if (priceInt == 0) {
      formattedPrice = 'FREE FOREVER';
    } else {
      double priceDouble = priceInt / 100.0;
      formattedPrice =
          '$currencyStr${priceDouble.toStringAsFixed(2)}$intervalStr';
    }

    // Promo tag from trial period
    int trialDays = json['trialPeriodDays'] ?? 0;
    String? promoTag;
    if (trialDays > 0 && nameRaw != 'FREE') {
      promoTag = '$trialDays DAYS FREE TRIAL';
    }

    return PlanModel(
      id: json['_id'] ?? json['id'] ?? '',
      rawName: nameRaw,
      name: displayName,
      tier: tier,
      price: formattedPrice,
      features:
          (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      badge: badge,
      promoTag: promoTag,
      isProBadge: isPro,
      isHighlighted: isHighlighted,
    );
  }
}
