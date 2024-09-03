// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';

class HomePageController extends GetxController {
  RxBool loading = false.obs;
  RxString isUser = "".obs;

  RxInt bottomNavIndex = 0.obs;
  void updateBottomNavIndex(int bottomNavIndex) =>
      this.bottomNavIndex.value = bottomNavIndex;

  //live session
  static int SessionsActiveTabIndex = 0;
}
