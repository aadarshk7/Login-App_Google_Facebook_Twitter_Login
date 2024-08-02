import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider extends ChangeNotifier {
  bool _isSignIn = false;
  bool get isSignIn => _isSignIn;
  SignInProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignIn = sp.getBool('isSignIn') ?? false;
    notifyListeners();
  }
}
