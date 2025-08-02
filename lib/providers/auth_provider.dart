import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/models/user_model.dart';
import 'package:simple_chat_app/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _authService = AuthService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String _errorMsg = '';

  //getter methods
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get errorMsg => _errorMsg;

  void _initializeAuth() {
    _authService.authStateChanges.listen((User? user) async {
      if (user != null) {
        _currentUser = await _authService.getCurrentUserData();
      }
    });
  }
}
