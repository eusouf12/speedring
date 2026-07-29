import 'package:get/get.dart';

class HomeController extends GetxController {
  final rxActiveTab = 0.obs; // 0: ALL, 1: EVENTS, 2: CLUBS
  void changeTab(int index) => rxActiveTab.value = index;
}
