import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon/Businessaccountpages/BusinessHomePage.dart';
import 'package:salon/home.dart';
import 'package:salon/loginOrRegister.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  Future<String?> getUserType(User? user) async {
    if (user != null) {
      try {
        final firestore = FirebaseFirestore.instance;

        // Check if the user document exists in 'users' collection
        final userDoc = await firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return 'users';
        }

        // Check if the user document exists in 'businesses_user_info' collection
        final businessUserDoc = await firestore
            .collection('businesses_user_info')
            .doc(user.uid)
            .get();
        if (businessUserDoc.exists) {
          return 'business';
        }
      } catch (e) {
        print('Error getting user type: $e');
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            final userType = getUserType(snapshot.data);
            return FutureBuilder<String?>(
              future: userType,
              builder: (context, AsyncSnapshot<String?> userTypeSnapshot) {
                if (userTypeSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading indicator while determining user type.
                }
                if (userTypeSnapshot.hasData) {
                  if (userTypeSnapshot.data == 'business') {
                    return BusinessHomeScreen();
                  } else if (userTypeSnapshot.data == 'users') {
                    return HomePage();
                  }
                }
                return LoginOrRegisterPage();
              },
            );
          } else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
