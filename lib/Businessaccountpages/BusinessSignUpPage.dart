import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon/AuthPages/authentication.dart';
// import 'package:salon/login.dart';

typedef void OnBusinessAccountCreated();

class BusinessSignupPage extends StatefulWidget {
  final OnBusinessAccountCreated onBusinessAccountCreated;
  // final bool isBusiness;
  BusinessSignupPage({
    required this.onBusinessAccountCreated,
    // required this.isBusiness,
  });
  @override
  _BusinessSignupPageState createState() => _BusinessSignupPageState();
}

class _BusinessSignupPageState extends State<BusinessSignupPage> {
  final TextEditingController _bemailController = TextEditingController();
  final TextEditingController _bfirstnameController = TextEditingController();
  final TextEditingController _blastnameController = TextEditingController();
  final TextEditingController _bpasswordController = TextEditingController();
  final TextEditingController _bconfirmpasswordController =
      TextEditingController();
  final TextEditingController _bphonenumberController = TextEditingController();
  final TextEditingController _blocationController = TextEditingController();
  Future<void> _createBusinesssAccount() async {
    try {
      if (_bpasswordController.text == _bconfirmpasswordController.text) {
        // Creating a firebase user with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _bemailController.text,
          password: _bpasswordController.text,
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AuthPage(),
        ));

        // Store additional user data in Firestore
        await FirebaseFirestore.instance
            .collection('businesses_user_info')
            .doc(userCredential.user!.uid)
            .set({
          'email': _bemailController.text,
          'password': _bpasswordController.text,
          'FirstName': _bfirstnameController.text,
          'LastName': _blastnameController.text,
          'PhoneNumber': _bphonenumberController.text,
          'BusinessLocation': _blocationController.text
        });
        widget.onBusinessAccountCreated();

        // Navigate to the home page after successful signup
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AuthPage(),
        ));
      } else {
        // Display an error message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Passwords don't match"),
        ));
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showerrormessage(e.code);
    }
  }

  void showerrormessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              message,
            ),
          );
        });
  }

  final InputDecoration _inputDecoration = InputDecoration(
      border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
  ));
  bool _validateInput() {
    if (_bemailController.text.isEmpty ||
        _bpasswordController.text.isEmpty ||
        _bconfirmpasswordController.text.isEmpty ||
        _bfirstnameController.text.isEmpty ||
        _blastnameController.text.isEmpty ||
        _bphonenumberController.text.isEmpty ||
        _blocationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please fill in all required fields.'),
      ));
      return false;
    }
    return true;
  }

  Future addBusinessUserDetails(
      String firstName, String lastName, String email, String location) async {
    await FirebaseFirestore.instance.collection('businesses_user_info').add({
      'First Name': firstName,
      'Last Name': lastName,
      'Email': email,
      'location': location
    });
  }

  @override
  Widget build(BuildContext context) {
    void closebusinessaccountalertbox() {
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Business Signup',
        ),
      ),
      body: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
                controller: _bfirstnameController,
                decoration: _inputDecoration.copyWith(hintText: 'First Name ')),
            SizedBox(height: 10),
            TextFormField(
              controller: _blastnameController,
              decoration: _inputDecoration.copyWith(hintText: 'Last Name'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _bemailController,
              decoration: _inputDecoration.copyWith(hintText: 'Email'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _bphonenumberController,
              decoration: _inputDecoration.copyWith(hintText: 'Phone Number'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _blocationController,
              decoration:
                  _inputDecoration.copyWith(hintText: 'Business location'),
            ),
            TextFormField(
              controller: _bpasswordController,
              decoration: _inputDecoration.copyWith(hintText: 'Password'),
              obscureText: true,
            ),
            TextFormField(
              controller: _bconfirmpasswordController,
              decoration:
                  _inputDecoration.copyWith(hintText: 'Confirm Password'),
              obscureText: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    //will contain validation code and check if any fields are empty.
                    if (_validateInput()) {
                      await _createBusinesssAccount();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: const Text('Create Business Account'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
