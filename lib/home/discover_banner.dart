import 'package:flutter/material.dart';

class DiscoverBanner extends StatelessWidget {
  const DiscoverBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: Color.fromARGB(56, 140, 204, 241),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text.rich(TextSpan(
            text: "DISCOVER AND BOOK LOCAL BEAUTY PROFFESIONALS",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ))));
  }
}
