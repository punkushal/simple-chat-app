import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<UserModel> _users = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void getUsersList(String currentUserId) {
    _setLoading(true);

    _databaseService
        .getAllUsers(currentUserId)
        .listen(
          (users) {
            _users = users;
            _setLoading(false);
          },
          onError: (error) {
            _setError(error.toString());
            _setLoading(false);
          },
        );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
}
