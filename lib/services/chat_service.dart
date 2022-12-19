import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/services/locator.dart';

import '../models/chat_item.dart';
import '../models/chat_list.dart';
import 'firestore_service.dart';

class ChatService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _messaging = FirebaseMessaging.instance;
  final firestoreService = locator.get<FirestoreService>();

  Stream<List<ChatItem>> chatStreams(String chatID) async* {
    yield* _db
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return ChatItem.fromJson(e.data());
      }).toList();
    });
  }

  Future<void> sendChat(String message, String chatId) async {
    // List<String> adminUids = await firestoreService.getAdminUids();
    final currentUid = _auth.currentUser!.uid;
    // adminUids.addIf(!adminUids.contains(currentUid), currentUid);
    await _db.collection('chats').doc(chatId).collection('messages').add({
      'sentBy': currentUid,
      'message': message,
      'time': FieldValue.serverTimestamp(),
    });

    // final ref = await _db
    //     .collection('chats')
    //     .where('participants', isEqualTo: adminUids)
    //     .get();
    // if (ref.docs.isNotEmpty) {
    //   final doc = ref.docs.first;
    //   await doc.reference.collection('messages').add({
    //     'sentBy': currentUid,
    //     'message': message,
    //     'time': FieldValue.serverTimestamp(),
    //   });
    // } else {
    //   log('Chat not found!');
    // }
    // doc.reference

  }

  Future<bool> chatExists() async {
    List<String> adminUids = await firestoreService.getAdminUids();
    final uid = _auth.currentUser!.uid;
    adminUids.addIf(!adminUids.contains(uid), uid);
    final query = await _db
        .collection('chats')
        .where('participants', isEqualTo: adminUids)
        .get();
    log('SIZE: ${query.size}');
    return query.size > 0;
  }

  Future<bool> adminChatExists() async {
    List<String> adminUids = await firestoreService.getAdminUids();
    final uid = _auth.currentUser!.uid;
    adminUids.addIf(!adminUids.contains(uid), uid);
    final query = await _db
        .collection('chats')
        .where('participants', isEqualTo: adminUids)
        .get();
    log('SIZE: ${query.size}');
    return query.size > 0;
  }

  Future<void> createChat() async {
    List<String> adminUids = await firestoreService.getAdminUids();
    final uid = _auth.currentUser!.uid;
    adminUids.addIf(!adminUids.contains(uid), uid);
    await _db.collection('chats').add({
      'participants': adminUids,
    });
  }

  Future<String> getAdminChatWithUser(String userUid) async {
    List<String> adminUids = await firestoreService.getAdminUids();
    adminUids.addIf(!adminUids.contains(userUid), userUid);
    final query = await _db
        .collection('chats')
        .where('participants', isEqualTo: adminUids)
        .get();
    return query.docs.first.id;
  }

  Future<String> createUserChatWithAdmin() async {
    List<String> adminUids = await firestoreService.getAdminUids();
    final uid = _auth.currentUser!.uid;
    adminUids.addIf(!adminUids.contains(uid), uid);
    final members = await getMembers(adminUids);
    final ref = await _db.collection('chats').add({
      'participantsData': members,
      'participants': adminUids,
      'isAdminChat': true,
    });
    return ref.id;
  }

  Future<List<Map<String, dynamic>>> getMembers(List<String> uids) async {
    List<Map<String, dynamic>> users = [];
    for (String uid in uids) {
      final user = await firestoreService.getUserByUid(uid);
      users.add(user.toJson());
    }
    return users;
  }

  Future<String> getUserChatWithAdminID() async {
    List<String> adminUids = await firestoreService.getAdminUids();
    final uid = _auth.currentUser!.uid;
    adminUids.addIf(!adminUids.contains(uid), uid);
    final query = await _db
        .collection('chats')
        .where('participants', isEqualTo: adminUids)
        .get();
    return query.docs.first.id;
  }

  Stream<List<ChatList>> getChatList() async* {
    final uid = _auth.currentUser!.uid;
    List<String> adminUids = await firestoreService.getAdminUids();
    adminUids.addIf(!adminUids.contains(uid), uid);
    yield* _db
        .collection('chats')
        .where('participants', isNotEqualTo: adminUids)
        .where('participants', arrayContains: uid)
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return ChatList.fromJson(e.data());
      }).toList();
    });
  }

  Stream<List<ChatList>> getAdminChatList() async* {
    log('AdminChatList');
    List<String> adminUids = await firestoreService.getAdminUids();
    yield* _db
        .collection('chats')
        .where('participants', arrayContainsAny: adminUids)
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return ChatList.fromJson(e.data());
      }).toList();
    });
  }
}
