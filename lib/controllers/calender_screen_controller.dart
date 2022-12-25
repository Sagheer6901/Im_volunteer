
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../routes/app_routes.dart';
import 'custom_bottom_navbar_controller.dart';


class CalenderScreenController extends GetxController{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late RxList<DateTime> toHighlight= <DateTime>[].obs;
  Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime> selectedDay=DateTime.now().obs;
  final kToday = DateTime.now();
   DateTime kFirstDay = DateTime(2022);
   DateTime kLastDay= DateTime(2100);
  CustomBottomNavBarController bottomNavigationController = Get.find(tag: AppRoutes.kBottomNavigationController);
  Future<bool> onWillPop() {
    bottomNavigationController.selectedNav.value = 2;
    Get.back();

    return Future.value(false);
  }

  @override
  Future<void> onInit() async {
    await FirebaseFirestore.instance
        .collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("${doc['eventDate']}");
        toHighlight.add(DateTime.fromMillisecondsSinceEpoch(doc['eventDate']));
      });
    });
    super.onInit();
  }
}