import 'dart:async';

import '../provider/sign_in_provider.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../utils/config.dart';
import '../utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // init state
  @override
  void initState() {
    final sp = context.read<SignInProvider>();
    super.initState();
    // create a timer of 2 seconds
    Timer(const Duration(seconds: 2), () {
      sp.isSignIn == false
          ? Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()))
          : Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));

      // ? nextScreen(context, const LoginScreen())
      // : nextScreen(context, const HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffFFC3A0),
              Color(0xff4e5cbc),
              Color(0xff1066b8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/mainimg.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Login App',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: <Color>[
                          Colors.red,
                          Colors.blue,
                        ],
                      ).createShader(
                        const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                      ),
                  ),
                ),
              )

              // const Center(
              //   child: Text(
              //     'Login Screen',
              //     style: TextStyle(
              //       fontSize: 30,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
