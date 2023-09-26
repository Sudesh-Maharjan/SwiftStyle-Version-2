import 'package:flutter/material.dart';
import 'package:salon/Businessaccountpages/BusinessEdit.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 166, 217, 226),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 32, 162, 174),
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                onTap: () {
                  // TODO: Implement notification functionality
                },
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: 18,
            ),
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/hi.png'),
              radius: 70,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 32, 162, 174),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text("Business Name"),
                    subtitle: Text("Nirjara Salon"),
                    leading: Icon(Icons.business),
                  ),
                  ListTile(
                    title: Text("City"),
                    subtitle: Text("Your City"),
                    leading: Icon(Icons.location_city),
                  ),
                  ListTile(
                    title: Text("Address"),
                    subtitle: Text("Your Address"),
                    leading: Icon(Icons.location_on),
                  ),
                  ListTile(
                    title: Text("Locality"),
                    subtitle: Text("Your Locality"),
                    leading: Icon(Icons.location_pin),
                  ),
                  ListTile(
                    title: Text("Phone Number"),
                    subtitle: Text("0000000000"),
                    leading: Icon(Icons.phone),
                  ),
                  ListTile(
                    title: Text("Services"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("- Haircut"),
                        Text("- Coloring"),
                        Text("- Styling"),
                        // Add more services as needed
                      ],
                    ),
                    leading: Icon(Icons.spa),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditPage()), // Navigate to EditPage
                );
              },
              child: Text(
                'Edit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 32, 162, 174),
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
