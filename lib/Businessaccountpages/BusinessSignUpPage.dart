import 'package:flutter/material.dart';

class BusinessSignupPage extends StatefulWidget {
  @override
  _BusinessSignupPageState createState() => _BusinessSignupPageState();
}

class _BusinessSignupPageState extends State<BusinessSignupPage> {
  final InputDecoration _inputDecoration = InputDecoration(
      border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
  ));

  @override
  Widget build(BuildContext context) {
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
                decoration: _inputDecoration.copyWith(hintText: 'First Name ')),
            SizedBox(height: 10),
            TextFormField(
              decoration: _inputDecoration.copyWith(hintText: 'Last Name'),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: _inputDecoration.copyWith(hintText: 'Email'),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: _inputDecoration.copyWith(hintText: 'Phone Number'),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration:
                  _inputDecoration.copyWith(hintText: 'Business location'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    //will contain validation code and check if any fields are empty.
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
