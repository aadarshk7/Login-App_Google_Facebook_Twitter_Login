import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login_app/provider/internet_provider.dart';
import 'package:login_app/provider/sign_in_provider.dart';
import 'package:login_app/screens/gradient_screen.dart';
import 'package:login_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'home_page.dart';
import 'login_page.dart';
import "package:flutter/src/painting/text_style.dart" as ts;
// import 'firebase_options.dart';flutter

// Code to connect with firebase databases
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyA0Q6ESxvyDTBys_jEGkuEofPX74mwCbs4",
            authDomain: "loginapp-87017.firebaseapp.com",
            projectId: "loginapp-87017",
            storageBucket: "loginapp-87017.appspot.com",
            messagingSenderId: "939288879280",
            appId: "1:939288879280:web:55e90537025b14526bdb75",
            measurementId: "G-FREWCBF7Y1"));
  }
  ;
// await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  const firebaseConfig = {
    'apiKey': "AIzaSyDx24fU-veTw_QttLg5mzgAJiDrYXv1EOM",
    'authDomain': "loginapp-87017.firebaseapp.com",
    'projectId': "loginapp-87017",
    'storageBucket': "loginapp-87017.appspot.com",
    'messagingSenderId': "939288879280",
    'appId': "1:939288879280:web:939288879280",
  };

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDx24fU-veTw_QttLg5mzgAJiDrYXv1EOM",
//   api key here
      appId: "loginapp-87017",
//  app id here
      messagingSenderId: "939288879280",
// messagingSenderId here
      projectId: "loginapp-87017", // project id here
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InternetProvider()),
        ChangeNotifierProvider(create: (_) => SignInProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Login',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

// class AuthWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);
//     return StreamBuilder<User?>(
//       stream: authService.user,
//       builder: (_, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           final User? user = snapshot.data;
//           return user == null ? LoginPage() : HomePage();
//         } else {
//           return Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//       },
//     );
//   }
// }
