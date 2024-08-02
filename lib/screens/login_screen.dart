import '../provider/internet_provider.dart';
import '../provider/sign_in_provider.dart';
import '../screens/home_screen.dart';
//import '../screens/phoneauth_screen.dart';
import '../utils/config.dart';
import '../utils/next_screen.dart';
import '../utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding:
            const EdgeInsets.only(left: 40, right: 40, top: 90, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage(Config.app_icon),
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Welcome to FlutterFirebase",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Learn Authentication with Provider",
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  )
                ],
              ),
            ),
            // Replace RoundedLoadingButton with ElevatedButton
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: handleGoogleSignIn,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.80, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
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
                // Facebook login button
                ElevatedButton(
                  onPressed: handleFacebookAuth,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.80, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Wrap(
                    children: const [
                      Icon(
                        FontAwesomeIcons.facebook,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text("Sign in with Facebook",
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
                // Twitter login button
                ElevatedButton(
                  onPressed: handleTwitterAuth,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlue,
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.80, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Wrap(
                    children: const [
                      Icon(
                        FontAwesomeIcons.twitter,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text("Continue with Twitter",
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
                // Phone Auth login button
                ElevatedButton(
                  onPressed: () {
                    nextScreenReplace(context, const HomeScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.80, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Wrap(
                    children: const [
                      Icon(
                        FontAwesomeIcons.phone,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text("Sign in with Phone",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }

  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString(), Colors.red);
        } else {
          sp.checkUserExists().then((value) async {
            if (value == true) {
              if (sp.uid != null) {
                await sp.getUserDataFromFirestore(sp.uid!).then((value) => sp
                    .saveDataToSharedPreferences()
                    .then((value) => sp.setSignIn().then((value) {
                          handleAfterSignIn();
                        })));
              }
            } else {
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

  Future handleFacebookAuth() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString(), Colors.red);
        } else {
          sp.checkUserExists().then((value) async {
            if (value == true) {
              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        handleAfterSignIn();
                      })));
            } else {
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

  Future handleTwitterAuth() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
    } else {
      await sp.signInWithTwitter().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString(), Colors.red);
        } else {
          sp.checkUserExists().then((value) async {
            if (value == true) {
              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        handleAfterSignIn();
                      })));
            } else {
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

  handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, const HomeScreen());
    });
  }
}
