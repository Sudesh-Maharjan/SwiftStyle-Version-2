import 'package:flutter/material.dart';
import 'package:salon/home/body.dart';

class HomeScreen extends StatelessWidget {
  static String routename = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
