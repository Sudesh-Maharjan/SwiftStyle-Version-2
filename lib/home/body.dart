import 'package:flutter/material.dart';
import 'package:salon/home/reccomendation.dart';
import 'categories.dart';
import 'discover_banner.dart';
import 'home_header.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            HomeHeader(),
            SizedBox(height: 30),
            DiscoverBanner(),
            SizedBox(height: 40),
            Categories(),
            SizedBox(height: 20),
            Reccomendation(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
