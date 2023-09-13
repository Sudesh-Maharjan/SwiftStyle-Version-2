import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchField(),
            Container(
              padding: EdgeInsets.all(12),
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                  color: Color.fromARGB(214, 95, 95, 93).withOpacity(0.1),
                  shape: BoxShape.circle),
              child: SvgPicture.asset("lib/icons/bell.svg"),
            )
          ],
        ));
  }
}
