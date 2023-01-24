import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddEventController extends GetxController{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var adminName,adminImage;
  void onBack() {
    Get.back();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    FirebaseFirestore.instance
        .collection('users').where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        adminName = doc['name'];
        adminImage = doc['image'];

        print(doc["first_name"]);
      });
    });
    super.onInit();
  }
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Rx<Uint8List?> webImage = Rx(Uint8List(8));
  var len = 1.obs;

  var localImage= "".obs;
  var lastDateForReg=DateTime.now().obs;
  var eventDate=DateTime.now().obs;
  eventDatePicker() async {
    eventDate.value = (await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(), //get today's date
        firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101)
    ))!;
  }
  lastDatePicker() async {
    lastDateForReg.value = (await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(), //get today's date
        firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101)
    ))!;
  }
  // TextEditingController passwordController = TextEditingController();
  pick() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicker =
    await picker.pickImage(source: ImageSource.gallery);
    if (imagePicker != null) {
      Uint8List bytes = await imagePicker.readAsBytes();
      webImage.value = bytes;
      len.value = bytes.length;
    } else {
      if (kDebugMode) {
        print('Pick Image First');
      }
    }
  }


  uploads() async {
      firebase_storage.Reference imageRef = firebase_storage
          .FirebaseStorage.instance
          .ref('eventImages/image-${DateTime.now()}');
      UploadTask task = imageRef.putData(webImage.value!);
      await Future.value(task);

      final docId =
          FirebaseFirestore.instance.collection('events').doc().id;
      // String docId = FirebaseFirestore.instance.collection("events").doc().id;
      FirebaseFirestore.instance.collection('events').doc(docId).set({
        "eventId" : docId,
        "adminImage": adminImage,
        "adminName": adminName,
        "applied": FieldValue.arrayUnion([""]),
        "eventDate":eventDate.value.millisecondsSinceEpoch,
        "lastDateForReg": lastDateForReg.value.millisecondsSinceEpoch,
        "description": descriptionController.text,
        // "eventId": FirebaseFirestore.instance.collection("events").doc().id,

        "image": await imageRef.getDownloadURL(),
        "likes": FieldValue.arrayUnion([""]),
        "openEvent": true,
        "title": titleController.text
      });
      // FirebaseFirestore.instance
      //     .collection('users')
      //     .doc("CHBmVSIxK6gJeMnEYgcD4sVbGdF2")
      //     .update({
      //   'image': localImage,
      // });
    }

}