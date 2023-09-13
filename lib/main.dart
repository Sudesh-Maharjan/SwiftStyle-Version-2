import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:salon/AuthPages/authentication.dart';
import 'package:salon/home.dart';

// import 'package:salon/login.dart';
// import 'package:salon/register.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // home: AuthPage(),
    home: const AuthPage(),
    routes: {
      // 'login': (context) => LoginPage(),
      // 'register': (context) => const Register(),
      'home': (context) => HomePage(),
      'authPage': (context) => const AuthPage(),
    },
  ));
}
