import 'package:flutter/material.dart';

class SectionNext extends StatelessWidget {
  const SectionNext({Key, key, required this.text, required this.press});
  final String text;
  final GestureTapDownCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style:
                TextStyle(fontSize: 18, color: Color.fromARGB(242, 10, 10, 10)),
          ),
          GestureDetector(onTap: () => press, child: Text("See More")),
        ],
      ),
    );
  }
}
