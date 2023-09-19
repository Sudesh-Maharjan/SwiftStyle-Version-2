import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon/Businessaccountpages/BusinessHomePage.dart';
import 'package:salon/loginOrRegister.dart';

class AuthPageBusiness extends StatelessWidget {
  // const AuthPage({Key? key}) : super(key: key);
  const AuthPageBusiness({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BusinessHomePage();
          } else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
