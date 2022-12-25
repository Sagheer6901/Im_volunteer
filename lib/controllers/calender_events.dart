
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../routes/app_routes.dart';
import 'custom_bottom_navbar_controller.dart';


class CalenderEventsController extends GetxController{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  CustomBottomNavBarController bottomNavigationController = Get.find(tag: AppRoutes.kBottomNavigationController);
  Future<bool> onWillPop() {
    bottomNavigationController.selectedNav.value = 0;
    Get.back();

    return Future.value(false);
  }

  @override
  void onInit() {
    super.onInit();
  }
}