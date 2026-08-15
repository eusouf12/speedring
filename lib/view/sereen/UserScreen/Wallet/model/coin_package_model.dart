class CoinPackageResponse {
  bool? success;
  String? message;
  List<CoinPackage>? data;

  CoinPackageResponse({this.success, this.message, this.data});

  CoinPackageResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CoinPackage>[];
      json['data'].forEach((v) {
        data!.add(CoinPackage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CoinPackage {
  String? id;
  String? name;
  num? coinsAmount;
  num? price;
  bool? isActive;
  String? icon;

  CoinPackage({
    this.id,
    this.name,
    this.coinsAmount,
    this.price,
    this.isActive,
    this.icon,
  });

  CoinPackage.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    coinsAmount = json['coinsAmount'];
    price = json['price'];
    isActive = json['isActive'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['coinsAmount'] = coinsAmount;
    data['price'] = price;
    data['isActive'] = isActive;
    data['icon'] = icon;
    return data;
  }
}
