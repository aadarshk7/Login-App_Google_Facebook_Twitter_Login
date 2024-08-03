import 'package:flutter/material.dart';

class GradientScreen extends StatelessWidget {
  const GradientScreen({super.key});

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
