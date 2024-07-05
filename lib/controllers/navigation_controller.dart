import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  void navigateToNewPageDownToUp(Widget page) {
    Get.to(() => page, transition: Transition.downToUp);
  }

  void navigateToNewPage(Widget page) {
    Get.to(() => page);
  }
}
