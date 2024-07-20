import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Setup',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firebase Setup Complete'),
        ),
        body: const Center(
          child: Text('Firebase is successfully configured on your app'),
        ),
      ),
    );
  }
}
