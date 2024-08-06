import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter_login/twitter_login.dart';

class SignInProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final twitterLogin = TwitterLogin(
      apiKey: Config.apikey_twitter,
      apiSecretKey: Config.secretkey_twitter,
      redirectURI: "loginapp://");

  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

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

  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

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

  Future signInWithTwitter() async {
    final twitterLogin = TwitterLogin(
      apiKey: 'gRU3proY3qP9l4ZGOig9Kq9oo',
      apiSecretKey: '6HOZ1cUjrF37uHSDsuPW5Dh9LsMhlFFvbtYDHiKXQ2d1vnO6BU',
      redirectURI: 'loginapp://',
    );

    final authResult = await twitterLogin.login();

    if (authResult.status == TwitterLoginStatus.loggedIn) {
      final authToken = authResult.authToken;
      final authTokenSecret = authResult.authTokenSecret;

      if (authToken != null && authTokenSecret != null) {
        final twitterAuthCredential = TwitterAuthProvider.credential(
          accessToken: authToken,
          secret: authTokenSecret,
        );

        try {
          final UserCredential userCredential =
              await firebaseAuth.signInWithCredential(twitterAuthCredential);
          final User? user = userCredential.user;

          if (user != null) {
            _uid = user.uid;
            _name = user.displayName;
            _email = user.email;
            _imageUrl = user.photoURL;
            _provider = "TWITTER";
            _hasError = false;
            notifyListeners();
          } else {
            _hasError = true;
            _errorCode = "User is null";
            notifyListeners();
          }
        } on FirebaseAuthException catch (e) {
          _hasError = true;
          _errorCode = e.message;
          notifyListeners();
        }
      } else {
        _hasError = true;
        _errorCode = "Auth token or secret is null";
        notifyListeners();
      }
    } else {
      _hasError = true;
      _errorCode = authResult.errorMessage;
      notifyListeners();
    }
  }

//sign in with X
  // sign in with twitter
  // Future signInWithTwitter() async {
  //   final authResult = await twitterLogin.loginV2();
  //   if (authResult.status == TwitterLoginStatus.loggedIn) {
  //     try {
  //       final credential = TwitterAuthProvider.credential(
  //           accessToken: authResult.authToken!,
  //           secret: authResult.authTokenSecret!);
  //       await firebaseAuth.signInWithCredential(credential);
  //
  //       final userDetails = authResult.user;
  //       // save all the data
  //       _name = userDetails!.name;
  //       _email = firebaseAuth.currentUser!.email;
  //       _imageUrl = userDetails.thumbnailImage;
  //       _uid = userDetails.id.toString();
  //       _provider = "TWITTER";
  //       _hasError = false;
  //       notifyListeners();
  //     } on FirebaseAuthException catch (e) {
  //       switch (e.code) {
  //         case "account-exists-with-different-credential":
  //           _errorCode =
  //               "You already have an account with us. Use correct provider";
  //           _hasError = true;
  //           notifyListeners();
  //           break;
  //
  //         case "null":
  //           _errorCode = "Some unexpected error while trying to sign in";
  //           _hasError = true;
  //           notifyListeners();
  //           break;
  //         default:
  //           _errorCode = e.toString();
  //           _hasError = true;
  //           notifyListeners();
  //       }
  //     }
  //   } else {
  //     _hasError = true;
  //     notifyListeners();
  //   }
  // }

// sign in with facebook
  Future signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    final graphResponse = await http.get(Uri.parse(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(200)&access_token=${result.accessToken!.tokenString}'));
    final profile = jsonDecode(graphResponse.body);
    if (result.status == LoginStatus.success) {
      try {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;
        _name = profile['name'];
        _email = userDetails.email;
        _imageUrl = profile['picture']['data']['url'];
        _provider = "FACEBOOK";
        _uid = userDetails.uid;
        _hasError = false;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Use correct provider";
            _hasError = true;
            notifyListeners();
            break;

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

  Future getUserDataFromFirestore(uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
              _uid = snapshot['uid'],
              _name = snapshot['name'],
              _email = snapshot['email'],
              _imageUrl = snapshot['image_url'],
              _provider = snapshot['provider'],
            });
  }

  Future saveDataToFirestore() async {
    final DocumentReference r =
        FirebaseFirestore.instance.collection("users").doc(uid);
    await r.set({
      "name": _name,
      "email": _email,
      "uid": _uid,
      "image_url": _imageUrl,
      "provider": _provider,
    });
    notifyListeners();
  }

  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();

    if (_name != null) {
      await s.setString('name', _name!);
    }
    if (_email != null) {
      await s.setString('email', _email!);
    }
    if (_uid != null) {
      await s.setString('uid', _uid!);
    }
    if (_imageUrl != null) {
      await s.setString('image_url', _imageUrl!);
    }
    if (_provider != null) {
      await s.setString('provider', _provider!);
    }

    notifyListeners();
  }

  Future getDataFromSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString('name');
    _email = s.getString('email');
    _imageUrl = s.getString('image_url');
    _uid = s.getString('uid');
    _provider = s.getString('provider');
    notifyListeners();
  }

  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (snap.exists) {
      print("EXISTING USER");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }

//for signout
  Future userSignOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    await facebookAuth.logOut();

    _isSignedIn = false;
    notifyListeners();
    //clear all storage information
    clearStoredData();
  }

  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
  }

  void phoneNumberUser(User user, email, name) {
    _name = name;
    _email = email;
    _imageUrl =
        "https://winaero.com/blog/wp-content/uploads/2017/12/User-icon-256-blue.png";
    _uid = user.phoneNumber;
    _provider = "PHONE";
    notifyListeners();
  }
}
