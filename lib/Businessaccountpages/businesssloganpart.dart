import 'package:flutter/material.dart';
import 'package:salon/Businessaccountpages/BusinessNextPage.dart';

class Slogan extends StatelessWidget {
  const Slogan({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20), // Adjusted margin
          padding: const EdgeInsets.symmetric(
              horizontal: 30, vertical: 20), // Adjusted padding
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 102, 193, 207),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Text(
              "CREATE YOUR PROFILE",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 9, 9, 9),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30, // Reduced the height
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            "Set where and when you work",
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(241, 10, 0, 0),
            ),
          ),
        ),
        const SizedBox(
          height: 20, // Reduced the height
        ),
        const Text(
          "Add your location and adjust your business hours to tell clients where and when you are available",
          style: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(241, 10, 0, 0),
          ),
        ),
        const SizedBox(
          height: 50, // Reduced the height
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            "Add your specialty and services",
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(241, 10, 0, 0),
            ),
          ),
        ),
        const SizedBox(
          height: 20, // Reduced the height
        ),
        const Text(
          "Let us know the area of your expertise and start by adding your services",
          style: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(238, 6, 1, 0),
          ),
        ),
        const SizedBox(
          height: 40, // Reduced the height
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            "Add Photos",
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(241, 10, 0, 0),
            ),
          ),
        ),
        const SizedBox(
          height: 20, // Reduced the height
        ),
        const Text(
          "Make them come to you by showing off your work!!",
          style: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(238, 6, 1, 0),
          ),
        ),
        const SizedBox(height: 120), // Reduced the height
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              // Navigates to the next page when the button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NextPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 102, 193, 207),
            ),
            child: const Text(
              'Create my Profile',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
