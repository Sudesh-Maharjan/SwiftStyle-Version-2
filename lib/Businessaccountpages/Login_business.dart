import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon/Businessaccountpages/BusinessHomePage.dart';

class BusinessLoginPage extends StatefulWidget {
  @override
  _BusinessLoginPageState createState() => _BusinessLoginPageState();
}

class _BusinessLoginPageState extends State<BusinessLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validatebusinessEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    //null or empty check garxa
    return null;
  }

  String? _validatebusinessPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    //
    return null;
  }

  Future<void> _showAlertDialog(String title, String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loginasBusinessUser() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (_formKey.currentState!.validate()) {
      try {
        // Authenticate the user
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        // Check if the user is authenticated
        if (userCredential.user != null) {
          // Query Firestore to find a document where email matches
          final QuerySnapshot<Map<String, dynamic>> queryResult =
              await FirebaseFirestore.instance
                  .collection('businesses_user_info')
                  .where('email', isEqualTo: email)
                  .limit(1)
                  .get();

          if (queryResult.docs.isNotEmpty) {
            final DocumentSnapshot<Map<String, dynamic>> userDoc =
                queryResult.docs.first;

            // You can further authorize the user here, e.g., by checking roles or permissions from Firestore

            // For example, you can navigate to BusinessHomePage:
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => BusinessHomePage(),
              ),
            );
          } else {
            // User not found in Firestore, handle accordingly
            _showAlertDialog(
                'Login Failed', 'User not found. Please check your email.');
          }
        } else {
          // User authentication failed, handle accordingly
          _showAlertDialog('Login Failed', 'Authentication failed.');
        }
      } catch (e) {
        // Handle errors that occur during login
        String errorMessage = 'An error occurred. Please try again.';
        if (e is FirebaseAuthException) {
          errorMessage = e.message ?? 'An error occurred. Please try again.';
        }
        print('Error: $errorMessage'); // Print the error for debugging

        _showAlertDialog('Login Failed', errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Business Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction, // Add this line
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: _validatebusinessEmail,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: _validatebusinessPassword,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _loginasBusinessUser();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Change button color to black
                  minimumSize:
                      Size(150, 40), // Set your desired width and height
                ),
                child: Text('Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
