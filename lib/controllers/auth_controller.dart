import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/services/auth_service.dart';
import 'package:i_am_volunteer/services/locator.dart';
import 'package:i_am_volunteer/utils/ui_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../services/messaging_service.dart';

class AuthController extends GetxController {
  final RxDouble splashLoading = 0.0.obs;
  Timer? timer;
  final registerFormKey = GlobalKey<FormState>();
  final loginFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final messaging = locator.get<MessagingService>();
  final authService = locator.get<AuthService>();
  RxBool loading = false.obs;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 3), () async {
      if (await authService.isLoggedIn()) {
        Get.offAllNamed(
          AppRoutes.homeScreen,
        );
      } else {
        Get.toNamed(
          AppRoutes.login,
        );
      }
    });
  }

  Future<void> signUp() async {
    // DocumentReference ref =
    // firestore.collection('users').doc(auth.currentUser!.uid);
    if (registerFormKey.currentState!.validate()) {
      loading.value = true;
      String email = emailController.text.toLowerCase().trim();
      String password = passwordController.text.trim();
      String name = nameController.text.trim();
      String? token = await messaging.getToken();
      final data = {
        'name': name,
        'email': email,
        'image': null,
        "batch":null,
        "cardIamge": null,
        "dept":null,
        "events": [],
        'role': Role.user.name,
        "phoneNumber": null,
        "rollNo": null,
        "volunteer": false,
        "uid": authService.user!.uid,
        'token': token,
      };
      UserModel user = UserModel.fromJson(data);
      final isUserCreated = await authService.createUser(
        user: user,
        password: password,
      );
      if (isUserCreated) {
        loading.value = false;
        // UiUtils.showPendingToast(
        //   'Account is pending verification\n Please wait till the verification complete.',
        // );
        Get.toNamed(
          AppRoutes.homeScreen,
        );
      } else {
        loading.value = false;
      }
    }
    // userCredential = await FirebaseAuth.instance
    //     .createUserWithEmailAndPassword(
    //     email: controller.emailController.text,
    //     password: controller.passwordController.text);
    // DocumentReference ref = FirebaseFirestore.instance
    //     .collection('Users')
    //     .doc(FirebaseAuth.instance.currentUser!.uid);
    // await ref.set({
    //   'docId': ref.id,
    //   'token': token,
    //   'email': controller.emailController.text.trim(),
    //   'role': "user",
    //   'name': controller.nameController.text.trim(),
    //   'password': controller.nameController.text.trim(),
    // }).whenComplete(() {
    //   flutterToast(
    //       msg:
    //       'Account is pending verification\n Please wait till the verification complete.',
    //       bgColor: Colors.red,
    //       toastLength: Toast.LENGTH_SHORT);
    // });
  }

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (loginFormKey.currentState!.validate()) {
      loading.value = true;
      final email = emailController.text.toLowerCase().trim();
      final password = passwordController.text.trim();
      final isLoggedIn = await authService.login(
        email: email,
        password: password,
      );
      if (isLoggedIn) {
        prefs.setString("email", email);
        Get.offAllNamed(AppRoutes.homeScreen);
      } else {
        loading.value = false;
      }
    }
  }
}
