import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/auth/models.dart' as auth_model;

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  auth_model.User? _user;
  auth_model.User? get localUser => _user;

  Future<String?> authenticateUser({
    required String name,
    required String email,
    required String password,
    bool isLogin = true,
  }) async {
    if (isLogin) {
      return await loginUser(email: email, password: password);
    }
    return await signupUser(name: name, email: email, password: password);
  }

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = auth_model.User(
        id: userCredential.user?.uid ?? "",
        name: userCredential.user?.displayName ?? "",
        email: email,
      );
      notifyListeners();
      return null;
    } catch (e) {
      debugPrint("loginUser error : $e");
      return "Authentication failed. Pls try again with valid credentials | $e";
    }
  }

  Future<String?> signupUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(name);
      _user = auth_model.User(
        id: userCredential.user?.uid ?? "",
        name: userCredential.user?.displayName ?? "",
        email: email,
      );
      notifyListeners();
      return null;
    } catch (e) {
      debugPrint("signupUser error : $e");
      return "Authentication failed. Pls try again | $e";
    }
  }

  void logoutUser() async {
    try {
      await _firebaseAuth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      debugPrint("logoutUser error : $e");
    }
  }
}
