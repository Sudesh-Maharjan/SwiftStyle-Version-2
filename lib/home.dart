import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon/home/home_screen.dart';
import 'package:salon/navigationbar/maps.dart';
import 'package:salon/navigationbar/profile.dart';

class HomePage extends StatelessWidget {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Set the app bar background color
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          ),
        ],
        title: Center(
          child: const Text(
            "SwiftStyle",
            style: const TextStyle(fontSize: 23, fontStyle: FontStyle.italic),
          ),
        ),
      ),
      body: Center(
        child: HomeScreen(), // Replace Text widget with HomeScreen class
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Colors.white, // Set the navigation bar background color
        unselectedItemColor: Colors.black, // Set the unselected item color
        selectedItemColor: Colors.black, // Set the selected item color
        onTap: (int index) {
          if (index == 0) {
            // Navigate to Home Page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            // Navigate to Maps Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapsPage()),
            );
          } else if (index == 2) {
            // Navigate to Profile Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Maps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
