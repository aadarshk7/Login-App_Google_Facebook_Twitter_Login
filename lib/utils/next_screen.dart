import 'package:flutter/material.dart';

void nextScreenReplace(BuildContext context, Widget nextScreen) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => nextScreen),
  );
}
