import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

class ManageVolunteersController extends GetxController
    with SingleGetTickerProviderMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController tabController;
  @override
  void onInit() {
    tabController = TabController(vsync: this, length: 2);
    super.onInit();
  }

  void onBack() {
    Get.back();
  }

  pdfCreation(admin) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(child: pw.Text("Hello world $admin"));
        },
        pageFormat: PdfPageFormat.a4));
    // final file = File("ex.pdf");

    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/ex.pdf');
    // print("path: $path");

    file.writeAsBytesSync(await pdf.save());
    if (file != null) {
      firebase_storage.Reference imageRef =
          firebase_storage.FirebaseStorage.instance.ref(
              'eventVolunteerCards/CHBmVSIxK6gJeMnEYgcD4sVbGdF2-${FirebaseAuth.instance.currentUser!.uid}');
      UploadTask task = imageRef.putData(file.readAsBytesSync());
      await Future.value(task);

      FirebaseFirestore.instance
          .collection('users')
          .doc("Y3feimlhlSOu4iDotiSK9nIM5ZC2")
          .collection("eventCards")
          .add({
        "eventId": "sfafsdfasfsdfasdfasdf",
        "eventName": "second of month",
        "volunteerCard": await imageRef.getDownloadURL()
      });
      // Share.shareFiles(subject: "appName", [file.path], text: 'pdf');
    }
  }

  shareImageUrl(String? name, String? imageUrl) async {
    // FlutterShare.share(title: appName, text: '$name \n \n $imageUrl');
    var filePath = await shareImage(imageUrl);
    if (filePath != null) {
      Share.shareFiles(subject: "appName", [filePath.path], text: '$name');
    }
  }

  Future<File?> shareImage(String? imageUrl) async {
    if (imageUrl != null) {
      final response = await get(Uri.parse(imageUrl));
      final temp = await getTemporaryDirectory();
      final File imageFile = File('${temp.path}/tempImage.jpg');
      imageFile.writeAsBytesSync(response.bodyBytes);
      return imageFile;
    }

    return null;
  }
}
