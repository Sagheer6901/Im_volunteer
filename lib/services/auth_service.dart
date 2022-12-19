import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:i_am_volunteer/services/locator.dart';
import 'package:i_am_volunteer/utils/ui_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _dbService = locator.get<FirestoreService>();
  UserModel? user;

  Future<bool> createUser({
    required UserModel user,
    required String password,
  }) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: password,
      );
      if (credentials.user != null) {
        user.uid = credentials.user?.uid;
        final isSaved = await _dbService.saveUserData(
          user,
        );
        this.user = await _dbService.getUserData(credentials.user!.uid);
        return isSaved;
      }
      return false;
    } on FirebaseAuthException catch (error) {
      log('ERROR: $error');
      UiUtils.showPendingToast('Error: ${error.message}');
      return false;
    }
  }

  Future<bool> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      log('ERROR: $e');
      UiUtils.showPendingToast('Error: $e');
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credentials.user != null) {
        print("users ${credentials.user!.uid}");
        await _dbService.updateToken(credentials.user!.uid);
        final user = await _dbService.getUserData(credentials.user!.uid);
        this.user = user;
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (error) {
      log('ERROR: $error');
      UiUtils.showPendingToast('Error: ${error.message}');
      print("error : ${error.message}");
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    if (_auth.currentUser != null) {
      final user = await _dbService.getUserData(_auth.currentUser!.uid);
      this.user = user;
      return true;
    } else {
      return false;
    }
  }
}
