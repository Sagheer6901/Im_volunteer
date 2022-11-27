import 'dart:developer';

import 'package:get/get.dart';
import 'package:i_am_volunteer/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import '../services/locator.dart';
import '../services/messaging_service.dart';

class CustomNavigationDrawerController extends GetxController {
  final messaging = locator.get<MessagingService>();
  final authService = locator.get<AuthService>();

  void onDrawerItemTap({required String screenName}) async {
    if (screenName == 'Chat Box') {
      // if (authService.user!.isAdmin()) {
      // } else {
      Get.toNamed(AppRoutes.chatScreen);
      // }
    } else if (screenName == 'Log Out') {
      await logout();
    }
  }

  Future<void> logout() async {
    final isLoggedOut = await authService.logout();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isLoggedOut) {
      log('LoggedOut!');
      await messaging.deleteToken();
      prefs.clear();
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
