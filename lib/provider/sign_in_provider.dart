import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/config.dart';

class SignInProvider extends ChangeNotifier {
  // instance of firebaseauth, facebook and google
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // final twitterLogin = TwitterLogin(
  //   //     apiKey: Config.apikey_twitter,
  //   //     apiSecretKey: Config.secretkey_twitter,
  //   //     redirectURI: "socialauth://");

  bool _isSignIn = false;

  bool get isSignIn => _isSignIn;

  //hasError, errorCode, provider,uid, email, name, imageUrl
  bool _hasError = false;

  bool get hasError => _hasError;

  String? _errorCode;

  String? get errorCode => _errorCode;

  String? _provider;

  String? get provider => _provider;

  String? _uid;

  String? get uid => _uid;

  String? _name;

  String? get name => _name;

  String? _email;

  String? get email => _email;

  String? _imageUrl;

  String? get imageUrl => _imageUrl;

  SignInProvider() {
    checkSignInUser();
  }

  Future<void> setSignIn() async {
    _isSignIn = true;
    notifyListeners();
  }

  Future<void> saveDataToFirestore() async {
    try {
      await _firestore.collection('users').doc(_uid).set({
        'name': _name,
        'email': _email,
        'imageUrl': _imageUrl,
        'provider': _provider,
      });
    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();
      notifyListeners();
    }
  }

  Future<bool> checkUserExists() async {
    DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
    return snap.exists;
  }

  Future checkSignInUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignIn = sp.getBool('isSignIn') ?? false;
    notifyListeners();
  }

  // sign in with google
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // executing our authentication
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // signing to firebase user instance
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        // now save all values
        _name = userDetails.displayName;
        _email = userDetails.email;
        _imageUrl = userDetails.photoURL;
        _provider = "GOOGLE";
        _uid = userDetails.uid;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Use correct provider";
            _hasError = true;
            notifyListeners();
            break;
          case "invalid-credential":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break; // Handle this case
          case "null":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> getUserDataFromFirestore(String uid) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      if (snap.exists) {
        _name = snap['name'];
        _email = snap['email'];
        _imageUrl = snap['imageUrl'];
        _provider = snap['provider'];
        notifyListeners();
      }
    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();
      notifyListeners();
    }
  }

  // Define the getDataFromSharedPreferences method
  Future<void> getDataFromSharedPreferences() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _name = sp.getString('name');
    _email = sp.getString('email');
    _imageUrl = sp.getString('imageUrl');
    _provider = sp.getString('provider');
    _uid = sp.getString('uid');
    notifyListeners();
  }

  Future<void> saveDataToSharedPreferences() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('name', _name ?? '');
    await sp.setString('email', _email ?? '');
    await sp.setString('imageUrl', _imageUrl ?? '');
    await sp.setString('provider', _provider ?? '');
    await sp.setString('uid', _uid ?? '');
    await sp.setBool('isSignIn', true);
    notifyListeners();
  }

// Define the userSignOut method
  Future<void> userSignOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    _isSignIn = false;
    notifyListeners();
  }
}
