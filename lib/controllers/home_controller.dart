import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/routes/app_routes.dart';
import 'package:i_am_volunteer/services/locator.dart';
import 'package:i_am_volunteer/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/firestore_service.dart';

class HomeScreenController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool indicator = false;
  final firestoreService = locator<FirestoreService>();

  // Future<void> apply(String eventId) async {
  //   await firestoreService.applyEvent(eventId);
  // }
  final uid = FirebaseAuth.instance.currentUser!.uid;
  apply(eventId, data) {
    FirebaseFirestore.instance
        .collection("events")
        .doc(eventId)
        .collection("volunteers")
        .add(data);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getEmail();
    super.onInit();
  }

  RxString? email = "".obs;
  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email!.value = prefs.getString("email")!;
  }

  void onApplyVolunteer(eventId) {
    final docRef = FirebaseFirestore.instance.collection("users").doc(uid);
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

          await firestoreService.applyVolunteer(eventId);

          // apply(eventId, data);
          // var dat;
          // FirebaseFirestore.instance
          //     .collection("events")
          //     .doc(eventId).get().then(
          //       (DocumentSnapshot doc) async {
          //     dat = doc.data() as Map<String, dynamic>;
          //
          //     FirebaseFirestore.instance.collection('volunteers').add(data);
          //
          //       },
          //   onError: (e) => print("Error getting document: $e"),
          // );
          // // print(data);

          // FirebaseFirestore.instance.collection('events').where(doc, isEqualTo: eventId);
          // final commentId = FirebaseFirestore.instance
          //     .collection('events')
          //     .doc(eventId)
          //     .collection('volunteers')
          //     .doc()
          //     .id;

          // FirebaseFirestore.instance
          //     .collection("events")
          //     .doc(eventId)
          //     .collection("volunteers")
          //     .doc(commentId)
          //     .set(data)
          //     .then((value) => Get.defaultDialog(
          //         title: "Volunteer Application",
          //         content: Text(
          //           "Applied Succcessfully! ",
          //           style: TextStyle(fontSize: 16, color: AppColors.primary),
          //         )));
          
          // var f = FirebaseFirestore.instance.collection("events").where("eventId", isEqualTo: eventId);

          // await FirebaseFirestore.instance.collection('events').doc(eventId).collection('volunteers').doc(commentId).update(data);
          // FirebaseFirestore.instance
          //     .collection("events")
          //     .doc(eventId)
          //     .collection("volunteers").doc(commentId)
          //     .add(data)
          //     .then((value) => Get.defaultDialog(
          //         title: "Volunteer Application",
          //         content: Text(
          //           "Applied Succcessfully! $value",
          //           style: TextStyle(fontSize: 16, color: AppColors.primary),
          //         )));

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

          // FirebaseFirestore.instance
          //     .collection('volunteers')
          //     .add(data)
          //     .then((value) => Get.defaultDialog(
          //         title: "Volunteer Application",
          //         content: Text(
          //           "Applied Succcessfully!",
          //           style: TextStyle(fontSize: 16, color: AppColors.primary),
          //         )));

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
