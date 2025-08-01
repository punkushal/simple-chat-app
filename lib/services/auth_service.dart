import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_chat_app/models/user_model.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  //To work with cloud firestore database
  final _firestore = FirebaseFirestore.instance;

  //To get the current user who already created his/her account
  User? get currentUser => _auth.currentUser;

  //To create new account using email and password
  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;

      if (user != null) {
        UserModel userModel = UserModel(
          name: name,
          email: email,
          createdAt: DateTime.now(),
          isOnline: true,
          uid: user.uid,
        );
        _firestore.collection('users').doc(user.uid).set(userModel.toMap());
      }

      log('Account created successfully');
    } catch (e) {
      log('Error: $e');
      throw Exception('Failed to create account: ${e.toString()}');
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      log('successfully logged in');
    } catch (e) {
      log('Error: $e');
    }
  }
}
