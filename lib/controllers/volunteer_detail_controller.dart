import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/comment_model.dart';
import '../services/firestore_service.dart';
import '../services/locator.dart';

class VolunteerDetailsController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final commentController = TextEditingController();
  RxBool isLoading = false.obs;
  final firestoreService = locator<FirestoreService>();
  Rx<List<CommentModel>> comments = Rx([]);

  void onBack() {
    Get.back();
  }

  void listenToComments(String vid) {
    firestoreService.getCommentsStreamVolunteer(vid).listen((comments) {
      const listEquality = ListEquality();
      final isEqual = listEquality.equals(this.comments.value, comments);
      if (!isEqual) {
        log('Comments: ${comments.length}');
        this.comments.value.clear();
        this.comments.value = [...comments];
      }
    });
  }


  Future<void> addComment(BuildContext context, String vid)
  async {
    final comment = commentController.text;
    if (comment.isNotEmpty) {
      try {
        Navigator.pop(context);
        isLoading.value = true;
        await firestoreService.addCommentVolunteer(vid, comment);
        isLoading.value = false;
        commentController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: $e',
            ),
          ),
        );
      }
    }
  }


  Future<void> likeComment(String vid, String commentId) async {
    await firestoreService.likeCommentVolunteer(vid, commentId);
  }

  Future<void> unlikeComment(String vid, String commentId) async {
    await firestoreService.unlikeCommentVolunteer(vid, commentId);
  }
}
