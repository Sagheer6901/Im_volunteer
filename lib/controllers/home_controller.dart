import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/routes/app_routes.dart';
import 'package:i_am_volunteer/services/locator.dart';
import 'package:i_am_volunteer/utils/app_colors.dart';

import '../services/firestore_service.dart';

class HomeScreenController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool indicator = false;
  final firestoreService = locator<FirestoreService>();

  // Future<void> apply(String eventId) async {
  //   await firestoreService.applyEvent(eventId);
  // }
  final uid = FirebaseAuth.instance.currentUser!.uid;
  apply(eventId){
   print("database");
   var data ={
     "email":"admin1@gmail.com"
   };
   FirebaseFirestore.instance.collection("events").doc(eventId).collection("volunteers").add(data) .then((value) => Get.defaultDialog(
       title: "Volunteer Application",
       content: Text(
         "Applied Succcessfully!",
         style: TextStyle(fontSize: 16, color: AppColors.primary),
       )));
 }
  void onApplyVolunteer(eventId) {
    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid);
    var data;
    docRef.get().then(
      (DocumentSnapshot doc) async {
        data = doc.data() as Map<String, dynamic>;
        if (doc['email'] == null ||
            doc['name'] == null ||
            doc['phoneNumber'] == null ||
            doc['dept'] == null ||
            doc['cardImage'] == null) {
          Get.snackbar(
              "Incomplete Profile", "Please complete your profile first",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.secondary);
        } else {
          await apply(eventId);

          //  // var ref =await FirebaseFirestore.instance.collection("volunteers").where("uid",isEqualTo: "Y3feimlhlSOu4iDotiSK9nIM5ZC2").get();
          //  // print(ref.docs.first);
          //
          //  FirebaseFirestore.instance.collection("users").where("events",isEqualTo: "Y3feimlhlSOu4iDotiSK9nIM5ZC2").get().then(
          //        (res) {
          //          print("docs ${res.docs}");
          //          for (var doc in res.docs) {
          //
          //            print("${doc.id} => ${doc.data()}");
          //          }
          //          },
          //    onError: (e) => print("Error completing: $e"),
          //  );
          //
          // final uid = FirebaseAuth.instance.currentUser!.uid;

          FirebaseFirestore.instance
              .collection('volunteers')
              .add(data)
              .then((value) => Get.defaultDialog(
                  title: "Volunteer Application",
                  content: Text(
                    "Applied Succcessfully!",
                    style: TextStyle(fontSize: 16, color: AppColors.primary),
                  )));

          // FirebaseFirestore.instance
          //     .collection('events')
          //     .doc("r8mwOsRXZxpBRYVBCYOb")
          //     .update({
          //   'likes': FieldValue.arrayUnion([uid]),
          // });
          // // FirebaseFirestore.instance.collection('users').doc('Y3feimlhlSOu4iDotiSK9nIM5ZC2').update({
          // //   'events': FieldValue.arrayUnion(["r8mwOsRXZxpBRYVBCYO1b"])
          // // });

        }
        // print("${doc['email']}  $data zinda");

        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
    print("${data} pak");
  }
}
