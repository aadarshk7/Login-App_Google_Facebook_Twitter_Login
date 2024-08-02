import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider extends ChangeNotifier {
  bool _isSignIn = false;
  bool get isSignIn => _isSignIn;
  SignInProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSignIn = prefs.getBool('isSignIn') ?? false;
    notifyListeners();
  }
}
