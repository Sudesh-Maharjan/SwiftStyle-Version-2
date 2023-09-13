import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage:
                    NetworkImage('https://example.com/profile_image.jpg'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                user.email!,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16.0),
              const Divider(),
              const SizedBox(height: 16.0),
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const ListTile(
                leading: Icon(Icons.phone),
                title: Text('+1 123 456 7890'),
              ),
              const ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Date of Birth'),
                subtitle: Text('January 1, 1990'),
              ),
              const SizedBox(height: 16.0),
              const Divider(),
              const SizedBox(height: 16.0),
              const Text(
                'Address',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const ListTile(
                leading: Icon(Icons.location_on),
                title: Text('123 Main St, City'),
                subtitle: Text('Country'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
