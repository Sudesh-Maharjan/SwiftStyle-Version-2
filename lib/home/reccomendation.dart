import 'package:flutter/material.dart';
import 'package:salon/home/section_next.dart';

class Reccomendation extends StatelessWidget {
  const Reccomendation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionNext(
          text: "Reccomendations ",
          press: (TapDownDetails details) {},
        ),
        SizedBox(
          height: 30,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ChoicesPage(
                image: 'lib/images/veda3.png',
                category: "Amrita's Salon",
                press: () {},
              ),
              ChoicesPage(
                image: 'lib/images/veda5.png',
                category: "Veda Station",
                press: () {},
              ),
              ChoicesPage(
                image: 'lib/images/hi.png',
                category: "Nirjara Beauty Salon",
                press: () {},
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ChoicesPage extends StatelessWidget {
  const ChoicesPage({
    super.key,
    required this.category,
    required this.image,
    required this.press,
  });
  final String category, image;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SizedBox(
        width: 350,
        height: 280,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(
                image,
                fit: BoxFit.fill,
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0xFF343434).withOpacity(0.4),
                      Color(0xFF343434).withOpacity(0.1),
                    ])),
              ),
              Padding(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 10, vertical: 0.5),
                child: Text.rich(TextSpan(
                    text: "$category",
                    style: TextStyle(
                      color: Color.fromARGB(255, 251, 251, 251),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
