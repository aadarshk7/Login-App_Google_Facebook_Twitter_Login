import 'dart:ui';
import '../utils/next_screen.dart';
import '../utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/internet_provider.dart';
import '../provider/sign_in_provider.dart';
import 'home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // handle after signin
  // handleAfterSignIn() {
  //   Future.delayed(const Duration(milliseconds: 1000)).then((value) {
  //     nextScreenReplace(context, const HomeScreen());
  //   });
  // }

  // Future<void> handleAfterSignIn() async {
  //   // Implement the actions to be taken after a successful sign-in
  //   Navigator.pushReplacementNamed(context, '/HomeScreen');
  // }
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // final googleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 377,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Positioned(
                  left: 128,
                  top: 339,
                  child: Text(
                    'Login App',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(44.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      handleGoogleSignIn();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundedLoadingButton(
                        onPressed: () {
                          handleGoogleSignIn();
                        },
                        controller: googleController,
                        successColor: Colors.red,
                        width: MediaQuery.of(context).size.width * 0.80,
                        elevation: 0,
                        borderRadius: 25,
                        color: Colors.red,
                        child: Wrap(
                          children: const [
                            Icon(
                              FontAwesomeIcons.google,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Sign in with Google",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forgot password?'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildSocialMediaButton('assets/images/xlogo.png',
                          onPressed: () {}),
                      _buildSocialMediaButton(
                          'assets/images/facebooklogopng.png', onPressed: () {
                        handleGoogleSignIn();
                      }),
                      _buildSocialMediaButton('assets/images/googlelogo.png',
                          onPressed: () {
                        // Call the Google sign-in method
                        handleGoogleSignIn();
                      }),
                      _buildSocialMediaButton('assets/images/github.png',
                          onPressed: () {}),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {},
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // handling google sign in
  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString(), Colors.red);
          googleController.reset();
        } else {
          // checking whether user exists or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exists
              if (sp.uid != null) {
                await sp.getUserDataFromFirestore(sp.uid!).then((value) => sp
                    .saveDataToSharedPreferences()
                    .then((value) => sp.setSignIn().then((value) {
                          googleController.reset();
                          handleAfterSignIn();
                        })));
              }
            } else {
              // user does not exist
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

  // handle after signin
  handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, const HomeScreen());
    });
  }

  Widget _buildSocialMediaButton(String assetName,
      {required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 50,
        height: 50,
        child: IconButton(
          icon: Image.asset(assetName),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
