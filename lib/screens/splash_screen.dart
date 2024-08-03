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
      sp.isSignedIn == false
          ? nextScreen(context, LoginScreen())
          : nextScreen(context, const HomeScreen());
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
              // Color(0xffFFC3A0),
              // Color(0xffFFAFBD),
              // Color(0xffFF9CE2),
              Colors.green,
              Colors.blue,
              Color(0xffFF9CE2),
              Color(0xffFFAFBD),
              Color(0xffFFC3A0),
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
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.blue, Colors.green],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    'Login Screen',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors
                          .white, // This color will be overridden by the ShaderMask
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
