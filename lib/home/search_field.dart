import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 306,
        height: 50,
        decoration: BoxDecoration(
          color: const Color.fromARGB(214, 95, 95, 93).withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          onChanged: (value) {
            //search value for future
          },
          decoration: const InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: "Search services",
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 15,
              )),
        ));
  }
}
