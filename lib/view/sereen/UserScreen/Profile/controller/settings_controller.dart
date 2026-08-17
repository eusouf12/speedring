import 'package:get/get.dart';
import 'package:speedring/helper/shared_prefe/shared_prefe.dart';

class SettingsController extends GetxController {
  RxBool isMetric = true.obs;

  // Visibility Toggles
  RxBool showTopSpeed = true.obs;
  RxBool showAvgSpeed = true.obs;
  RxBool showDistance = true.obs;
  RxBool showGForce = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    bool? savedMetric = await SharePrefsHelper.getBool('isMetric');
    if (savedMetric != null) {
      isMetric.value = savedMetric;
    } else {
      isMetric.value = true; // default to true
    }

    showTopSpeed.value = await SharePrefsHelper.getBool('showTopSpeed') ?? true;
    showAvgSpeed.value = await SharePrefsHelper.getBool('showAvgSpeed') ?? true;
    showDistance.value = await SharePrefsHelper.getBool('showDistance') ?? true;
    showGForce.value = await SharePrefsHelper.getBool('showGForce') ?? true;
  }

  void toggleUnitSystem() {
    isMetric.value = !isMetric.value;
    SharePrefsHelper.setBool('isMetric', isMetric.value);
  }

  void toggleTopSpeed() {
    showTopSpeed.value = !showTopSpeed.value;
    SharePrefsHelper.setBool('showTopSpeed', showTopSpeed.value);
  }

  void toggleAvgSpeed() {
    showAvgSpeed.value = !showAvgSpeed.value;
    SharePrefsHelper.setBool('showAvgSpeed', showAvgSpeed.value);
  }

  void toggleDistance() {
    showDistance.value = !showDistance.value;
    SharePrefsHelper.setBool('showDistance', showDistance.value);
  }

  void toggleGForce() {
    showGForce.value = !showGForce.value;
    SharePrefsHelper.setBool('showGForce', showGForce.value);
  }

  String get speedUnit => isMetric.value ? 'KM/H' : 'MPH';
  String get distanceUnit => isMetric.value ? 'KM' : 'MI';
  
  // Conversions
  double getSpeed(double speedKmh) {
    return isMetric.value ? speedKmh : speedKmh * 0.621371;
  }

  double getDistance(double distanceKm) {
    return isMetric.value ? distanceKm : distanceKm * 0.621371;
  }
}
