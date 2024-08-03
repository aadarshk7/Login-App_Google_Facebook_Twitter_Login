// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:login_app/screens/login_screen.dart';
//
// import '../login_page.dart';
//
// class Googlescreen extends StatefulWidget {
//   const Googlescreen({super.key});
//
//   @override
//   State<Googlescreen> createState() => _GooglescreenState();
// }
//
// class _GooglescreenState extends State<Googlescreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ElevatedButton(
//         onPressed: () {
//           signInWithGoogle();
//         },
//         child: Center(child: const Text('Login with Google!')),
//       ),
//     );
//   }
//
//   signInWithGoogle() async {
//     GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
//     GoogleSignInAuthentication? googleSignInAuthentication =
//         await googleSignInAccount?.authentication;
//
//     AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleSignInAuthentication?.accessToken,
//       idToken: googleSignInAuthentication?.idToken,
//     );
//
//     UserCredential userCredential =
//         await FirebaseAuth.instance.signInWithCredential(credential);
//     // Perform some action when the button is clicked
//     print(userCredential.user?.displayName);
//
//     if (userCredential.user != null) {
//       Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => LoginPage(
//                 userName: '',
//               )));
//     }
//
//     // FirebaseAuth.instance.signInWithCredential(AuthCredential(providerId: providerId, signInMethod: signInMethod)));
//     // Perform some action when the button is clicked
//   }
// }
