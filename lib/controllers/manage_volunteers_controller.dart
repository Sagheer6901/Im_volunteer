import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:i_am_volunteer/utils/app_assets.dart';
import 'package:i_am_volunteer/utils/app_colors.dart';
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

  pdfCreation(admin, vid, eventId, uid, userData) async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Container(
                  margin: pw.EdgeInsets.all(25),
                  padding: pw.EdgeInsets.all(50),
                  width: 350,
                  decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.purple400),
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(5))),
                  child: pw.Column(children: [
                    pw.Text(userData["name"],
                        style: pw.TextStyle(
                          fontSize: 24,
                        )),
                    pw.Text(
                      userData["email"],
                      style: pw.TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    pw.Text(
                      userData["dept"],
                      style: pw.TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    pw.Text(
                      userData["batch"].toString(),
                      style: pw.TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    pw.Text(
                      "Im Volunteer",
                      style: pw.TextStyle(
                        fontSize: 30,
                        color: PdfColors.purple800
                      ),
                    )
                  ])));
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
              'eventVolunteerCards/$eventId-${FirebaseAuth.instance.currentUser!.uid}');
      UploadTask task = imageRef.putData(file.readAsBytesSync());
      await Future.value(task);

      FirebaseFirestore.instance //////////// not working
          .collection('users')
          .doc(uid)
          .collection("eventCards")
          .add({
        "eventId": "$eventId",
        "eventName": "second of month",
        "volunteerCard": await imageRef.getDownloadURL()
      });
      FirebaseFirestore.instance

          /// working properly
          .collection('events')
          .doc(eventId)
          .collection("volunteers")
          .doc(vid)
          .update({"volunteer": true});
      FirebaseFirestore.instance

          /// working properly
          .collection('users')
          .doc(uid)
          .update({"volunteer": true});
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
