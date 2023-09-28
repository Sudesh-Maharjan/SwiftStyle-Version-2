import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:salon/Hairpage/hair.dart';
import 'package:salon/Hairpage/PopulateHairPage.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": "lib/icons/hair.svg", "text": "Hair"},
      {"icon": "lib/icons/nails.svg", "text": "Nails"},
      {"icon": "lib/icons/makeup.svg", "text": "Make-Up"},
      // {"icon": "lib/icons/offers.svg", "text": "Offers "},
      // {"icon": "lib/icons/more.svg", "text": "More"},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
              categories.length,
              (index) => CategoryCard(
                    icon: categories[index]["icon"],
                    text: categories[index]["text"],
                    press: () {
                      if (categories[index]["text"] == "Hair") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HairPagepopulation(),
                          ),
                        );
                      }
                    },
                  ))
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {Key, key, required this.icon, required this.text, required this.press})
      : super(key: key);

  final String icon, text;
  final GestureTapCallback press;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: 55,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color.fromARGB(56, 140, 204, 241),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.asset(icon),
              ),
            ),
            const SizedBox(height: 5),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
