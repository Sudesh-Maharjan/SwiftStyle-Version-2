import 'package:flutter/material.dart';

class BusinessHomePage extends StatefulWidget {
  @override
  State<BusinessHomePage> createState() => _BusinessHomePageState();
}

class _BusinessHomePageState extends State<BusinessHomePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Business Name'),
      ),
    );
  }
}
