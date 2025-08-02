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

  //To get auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  //To create new account using email and password
  Future<UserModel?> signUpWithEmailAndPassword(
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
        return userModel;
      }

      log('Account created successfully');
    } catch (e) {
      log('Error: $e');
      throw Exception('Failed to create account: ${e.toString()}');
    }
    return null;
  }

  //Login user
  Future<UserModel?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;
      if (user != null) {
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      }
      log('successfully logged in');
    } catch (e) {
      log('Error: $e');
      throw Exception('Sign in failed: ${e.toString()}');
    }
    return null;
  }

  //To log out user
  Future<void> signout() async {
    try {
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser!.uid).update({
          'isOnline': false,
        });
        await _auth.signOut();
      }
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  //To get current user data
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUser != null) {
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      log('Error while fetching user data: $e');
    }
    return null;
  }
}
