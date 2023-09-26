import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon/Businessaccountpages/Businessbody.dart';

class BusinessHomeScreen extends StatelessWidget {
  static String routename = "/home";

  void _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login page
      Navigator.of(context)
          .pushReplacementNamed('/login'); // Replace with your login page route
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Page'), // Set the app bar title
        backgroundColor: Colors.black, // Set the background color to black
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Add logout icon
            onPressed: () {
              _handleLogout(
                  context); // Call the logout function on button press
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 188, 221, 226),
      body: Body(),
    );
  }
}
