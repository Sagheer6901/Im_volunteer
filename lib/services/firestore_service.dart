import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/comment_model.dart';
import '../models/user_model.dart';
import '../utils/ui_utils.dart';
import 'locator.dart';
import 'messaging_service.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  final _messaging = locator<MessagingService>();

  Future<bool> saveUserData(UserModel user) async {
    try {
      await _db.collection('users').doc(user.uid).set(user.toJson());
      return true;
    } catch (e) {
      log('ERROR: $e');
      UiUtils.showPendingToast('Unknown error, please try again!');
      return false;
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      final userDoc = await _db.collection('users').doc(uid).get();
      if (userDoc.data() != null) {
        UserModel user = UserModel.fromJson(userDoc.data()!);
        return user;
      }
      throw Exception();
    } catch (e) {
      log('ERROR: $e');
      UiUtils.showPendingToast('Unknown error, please try again!');
      return null;
    }
  }

  Future<void> updateToken(String uid) async {
    final token = await _messaging.getToken();
    await _db.collection('users').doc(uid).update({
      'token': token,
    });
  }

  Future<List<String>> getAdminUids() async {
    final docs = await _db
        .collection('users')
        .where('role', isEqualTo: Role.admin.name)
        .get();
    List<String> uids = List.generate(docs.size, (index) {
      final user = UserModel.fromJson(docs.docs[index].data());
      return user.uid!;
    });
    return uids;
  }

  Future<UserModel> getUserByUid(String uid) async {
    final userDoc = await _db.collection('users').doc(uid).get();
    final user = UserModel.fromJson(userDoc.data()!);
    return user;
  }

  Future<void> addComment(String eventId, String comment) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final user = await getUserByUid(uid);
      final commentId =
          _db.collection('events').doc(eventId).collection('comments').doc().id;
      await _db
          .collection('events')
          .doc(eventId)
          .collection('comments')
          .doc(commentId)
          .set({
        'commentId': commentId,
        'comment': comment,
        'commentBy': user.toJson(),
        'time': FieldValue.serverTimestamp(),
        'likes': [],
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addCommentVolunteer(String vid, String comment) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final user = await getUserByUid(uid);
      final commentId =
          _db.collection('users').doc(vid).collection('comments').doc().id;
      await _db
          .collection('users')
          .doc(vid)
          .collection('comments')
          .doc(commentId)
          .set({
        'commentId': commentId,
        'comment': comment,
        'commentBy': user.toJson(),
        'time': FieldValue.serverTimestamp(),
        'likes': [],
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> applyVolunteer(String eventId,userData) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final user = await getUserByUid(uid);
      final commentId =
          _db.collection('events').doc(eventId).collection('volunteers').doc().id;
      userData['vid'] = commentId;
      userData['eventVolunteer']= false;
      await _db
          .collection('events')
          .doc(eventId)
          .collection('volunteers')
          .doc(commentId)
          .set(userData);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<CommentModel>> getCommentsStreamVolunteer(String vid) {
    return _db
        .collection('users')
        .doc(vid)
        .collection('comments')
        .orderBy('time', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((commentDoc) {
        final data = commentDoc.data();
        return CommentModel.fromJson(data);
      }).toList();
    });
  }

  Stream<List<CommentModel>> getCommentsStream(String eventId) {
    return _db
        .collection('events')
        .doc(eventId)
        .collection('comments')
        .orderBy('time', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((commentDoc) {
        final data = commentDoc.data();
        return CommentModel.fromJson(data);
      }).toList();
    });
  }

  Future<void> likeComment(String eventId, String commentId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _db
        .collection('events')
        .doc(eventId)
        .collection('comments')
        .doc(commentId)
        .update({
      'likes': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> likeCommentVolunteer(String eventId, String commentId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _db
        .collection('users')
        .doc(eventId)
        .collection('comments')
        .doc(commentId)
        .update({
      'likes': FieldValue.arrayUnion([uid]),
    });
  }
  Future<void> unlikeCommentVolunteer(String eventId, String commentId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _db
        .collection('users')
        .doc(eventId)
        .collection('comments')
        .doc(commentId)
        .update({
      'likes': FieldValue.arrayRemove([uid]),
    });
  }

  Future<void> unlikeComment(String eventId, String commentId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _db
        .collection('events')
        .doc(eventId)
        .collection('comments')
        .doc(commentId)
        .update({
      'likes': FieldValue.arrayRemove([uid]),
    });
  }

  Future<void> likeEvent(String eventId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _db.collection('events').doc(eventId).update({
      'likes': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> applyEvent(String eventId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _db.collection('events').doc(eventId).update({
      'applied': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> unlikeEvent(String eventId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _db.collection('events').doc(eventId).update({
      'likes': FieldValue.arrayRemove([uid]),
    });
  }

  Future<String> getNameById(String uid) async {
    final userDoc = await _db.collection('users').doc(uid).get();
    final user = UserModel.fromJson(userDoc.data()!);
    return user.name!;
  }
}
