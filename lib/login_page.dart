import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_app/screens/home_screen.dart';
import 'package:login_app/utils/next_screen.dart';
import 'package:login_app/utils/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:twitter_login/twitter_login.dart';
import 'auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../provider/internet_provider.dart';
import '../provider/sign_in_provider.dart';
import '../utils/config.dart';
import '../utils/next_screen.dart';
import '../utils/snack_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//  final String userName;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController googleController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(,
      // title: Text(userName),
      // actions: [
      //   IconButton(
      //     // icon: const Icon(Icons.logout),
      //     onPressed: () async {
      //       GoogleSignIn().signOut();
      //       FirebaseAuth.instance.signOut();
      //     },
      //     icon: Icon(Icons.logout),
      //   ),
      // ],
      //),

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
                // Center(
                //   child: Text('Welcome, $userName!!'),
                // ),
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
                    onPressed: () {},
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
                      child: Text(
                        'Sign In',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {},
                    child: Text('Forgot password?'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildSocialMediaButton(
                          'assets/images/xlogo.png', handleTwitterAuth),
                      _buildSocialMediaButton(
                          'assets/images/facebooklogopng.png',
                          handleFacebookAuth),
                      _buildSocialMediaButton(
                          'assets/images/googlelogo.png', handleGoogleSignIn),
                      _buildSocialMediaButton(
                          'assets/images/github.png', handleGoogleSignIn),
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

  Widget _buildSocialMediaButton(String assetName, VoidCallback onPressed) {
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
          // checking whether user exists or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user already exists
              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        handleAfterSignIn();
                      })));
            } else {
              // user does not exist
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

  // handling twitter auth
  // Future handleTwitterAuth() async {
  //   final sp = context.read<SignInProvider>();
  //   final ip = context.read<InternetProvider>();
  //   await ip.checkInternetConnection();
  //
  //   if (ip.hasInternet == false) {
  //     openSnackbar(context, "Check your Internet connection", Colors.red);
  //     twitterController.reset();
  //   } else {
  //     await sp.signInWithTwitter().then((value) {
  //       if (sp.hasError == true) {
  //         openSnackbar(context, sp.errorCode.toString(), Colors.red);
  //         twitterController.reset();
  //       } else {
  //         // checking whether user exists or not
  //         sp.checkUserExists().then((value) async {
  //           if (value == true) {
  //             // user exists
  //             await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
  //                 .saveDataToSharedPreferences()
  //                 .then((value) => sp.setSignIn().then((value) {
  //                       twitterController.success();
  //                       handleAfterSignIn();
  //                     })));
  //           } else {
  //             // user does not exist
  //             sp.saveDataToFirestore().then((value) => sp
  //                 .saveDataToSharedPreferences()
  //                 .then((value) => sp.setSignIn().then((value) {
  //                       // twitterController.success();
  //                       handleAfterSignIn();
  //                     })));
  //           }
  //         });
  //       }
  //     });
  //   }
  // }

  // handling google sigin in

  // Future handleTwitterAuth() async {
  //   final sp = context.read<SignInProvider>();
  //   final ip = context.read<InternetProvider>();
  //   await ip.checkInternetConnection();
  //
  //   if (ip.hasInternet == false) {
  //     openSnackbar(context, "Check your Internet connection", Colors.red);
  //   } else {
  //     await sp.signInWithTwitter().then((value) {
  //       if (sp.hasError == true) {
  //         openSnackbar(context, sp.errorCode.toString(), Colors.red);
  //       } else {
  //         // checking whether user exists or not
  //         sp.checkUserExists().then((value) async {
  //           if (value == true) {
  //             // user exists
  //             await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
  //                 .saveDataToSharedPreferences()
  //                 .then((value) => sp.setSignIn().then((value) {
  //                       handleAfterSignIn();
  //                     })));
  //           } else {
  //             // user does not exist
  //             sp.saveDataToFirestore().then((value) => sp
  //                 .saveDataToSharedPreferences()
  //                 .then((value) => sp.setSignIn().then((value) {
  //                       handleAfterSignIn();
  //                     })));
  //           }
  //         });
  //       }
  //     });
  //   }
  // }

  // Handling Twitter authentication
  // Future handleTwitterAuth() async {
  //   final sp = context.read<SignInProvider>();
  //   final ip = context.read<InternetProvider>();
  //   await ip.checkInternetConnection();
  //
  //   if (ip.hasInternet == false) {
  //     openSnackbar(context, "Check your Internet connection", Colors.red);
  //   } else {
  //     await sp.signInWithTwitter().then((value) {
  //       if (sp.hasError == true) {
  //         openSnackbar(context, sp.errorCode.toString(), Colors.red);
  //         //twitterController.reset();
  //       } else {
  //         // checking whether user exists or not
  //         sp.checkUserExists().then((value) async {
  //           if (value == true) {
  //             // user exists
  //             await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
  //                 .saveDataToSharedPreferences()
  //                 .then((value) => sp.setSignIn().then((value) {
  //                       // twitterController.success();
  //                       handleAfterSignIn();
  //                     })));
  //           } else {
  //             // user does not exist
  //             sp.saveDataToFirestore().then((value) => sp
  //                 .saveDataToSharedPreferences()
  //                 .then((value) => sp.setSignIn().then((value) {
  //                       // twitterController.success();
  //                       handleAfterSignIn();
  //                     })));
  //           }
  //         });
  //       }
  //     });
  //   }
  // }

  // Future handleTwitterAuth() async {
  //     final twitterLogin = TwitterLogin(
  //       // consumerKey: Config.apikey_twitter,
  //       // consumerSecret: Config.secretkey_twitter,
  //       apiKey: 'gRU3proY3qP9l4ZGOig9Kq9oo',
  //       apiSecretKey: '6HOZ1cUjrF37uHSDsuPW5Dh9LsMhlFFvbtYDHiKXQ2d1vnO6BU',
  //       redirectURI: 'loginapp://',
  //     );
  //
  //     final authResult = await twitterLogin.login();
  //
  //     switch (authResult.status) {
  //       case TwitterLoginStatus.loggedIn:
  //         final authToken = authResult.authToken!;
  //         final authTokenSecret = authResult.authTokenSecret!;
  //
  //         // Use the Twitter session to sign in with Firebase
  //         final twitterAuthCredential = TwitterAuthProvider.credential(
  //           accessToken: authToken,
  //           secret: authTokenSecret,
  //         );
  //
  //         try {
  //           await FirebaseAuth.instance
  //               .signInWithCredential(twitterAuthCredential);
  //           handleAfterSignIn();
  //         } catch (e) {
  //           openSnackbar(context, "Error: $e", Colors.red);
  //         }
  //         break;
  //
  //       case TwitterLoginStatus.cancelledByUser:
  //         openSnackbar(context, "Twitter login cancelled", Colors.red);
  //         break;
  //
  //       case TwitterLoginStatus.error:
  //         openSnackbar(context,
  //             "Twitter login error: ${authResult.errorMessage}", Colors.red);
  //         break;
  //       case null:
  //       // TODO: Handle this case.
  //     }
  //   }
  // }

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
          // checking whether user exists or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exists
              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        handleAfterSignIn();
                      })));
            } else {
              // user does not exist
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

  // handling facebookauth
  Future handleFacebookAuth() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      facebookController.clear();
    } else {
      await sp.signInWithFacebook().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString(), Colors.red);
          //facebookController.reset();
        } else {
          // checking whether user exists or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exists
              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        handleAfterSignIn();
                      })));
            } else {
              // user does not exist
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
