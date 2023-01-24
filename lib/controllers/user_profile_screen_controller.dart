import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/controllers/custom_bottom_navbar_controller.dart';
import 'package:i_am_volunteer/routes/app_routes.dart';
import 'package:i_am_volunteer/services/auth_service.dart';
import 'package:i_am_volunteer/services/locator.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreenController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  TextEditingController batchController = TextEditingController();
  final authService = locator.get<AuthService>();
  CustomBottomNavBarController bottomNavigationController = Get.find(tag: AppRoutes.kBottomNavigationController);

  // TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController deptController = TextEditingController();
  // Uint8List? webImage, webImage1 = Uint8List(8);
  Rx<Uint8List?> webImage = Rx(Uint8List(8));
  Rx<Uint8List?> webImage1 = Rx(Uint8List(8));

  String? localImage, localImage1;
  // TextEditingController passwordController = TextEditingController();
  Future<bool> onWillPop() {
    bottomNavigationController.selectedNav.value = 2;
    Get.back();

    return Future.value(false);
  }
  pick(imageType) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicker =
        await picker.pickImage(source: ImageSource.gallery);
    if (imagePicker != null) {
      Uint8List bytes = await imagePicker.readAsBytes();
      if (imageType == 1) {
        webImage.value = bytes;
      } else {
        webImage1.value = bytes;
      }
    } else {
      if (kDebugMode) {
        print('Pick Image First');
      }
    }
  }

  uploads(imageType) async {
    if (imageType == 1) {
      firebase_storage.Reference imageRef = firebase_storage
          .FirebaseStorage.instance
          .ref('userImages/${FirebaseAuth.instance.currentUser!.uid}-profile');
      UploadTask task = imageRef.putData(webImage.value!);
      await Future.value(task);
      localImage = await imageRef.getDownloadURL();
      FirebaseFirestore.instance
          .collection('users')
          .doc("${FirebaseAuth.instance.currentUser!.uid}")
          .update({
        'image': localImage,
      }).then((value) {
        localImage = null;
      });
    } else {
      firebase_storage.Reference imageRef = firebase_storage
          .FirebaseStorage.instance
          .ref('userImages/${FirebaseAuth.instance.currentUser!.uid}-card');
      UploadTask task = imageRef.putData(webImage1.value!);
      await Future.value(task);
      localImage1 = await imageRef.getDownloadURL();
      FirebaseFirestore.instance
          .collection('users')
          .doc("${FirebaseAuth.instance.currentUser!.uid}")
          .update({
        'cardImage': localImage1,
      }).then((value) {
        // localImage1 = null;
      });
    }
  }

  // Future resetEmail(String newEmail) async {
  //   var message;
  //   final user = FirebaseAuth.instance.currentUser;
  //   // await FirebaseAuth.instance.currentUser!.updateEmail(newEmail)
  //   //     .then(
  //   //       (value) => message = 'Success',
  //   // ).catchError((onError) => message = 'error');
  //   if (user != null) {
  //     final result = await InternetAddress.lookup('google.com');
  //     try {
  //       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //         user.updateEmail(newEmail);
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc("CHBmVSIxK6gJeMnEYgcD4sVbGdF2")
  //       .update({
  //     'email': newEmail,
  //   }).then((value) {
  //     onBack();
  //     localImage = null;
  //   });
  //   return message;
  // }


}
