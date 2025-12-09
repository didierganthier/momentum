import 'package:flutter/widgets.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _auth = AuthService();

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthViewModel() {
    _auth.userChanges.listen((user) {
      _isLoggedIn = user != null;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    await _auth.login(email, password);
  }

  Future<void> register(String email, String password) async {
    await _auth.register(email, password);
  }

  Future<void> logout() async {
    await _auth.logout();
  }
}
