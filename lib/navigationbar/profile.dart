import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
//function confirmation dialog show garauna ko lagi to dofirm deleting account
  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: TextStyle(color: Colors.red),
              ),
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                // Add code here to delete the user account using Firebase Auth
                // For example:
                try {
                  await user.delete();
                  Navigator.of(context).pop(); // Close the dialog
                  // You can also navigate the user to a sign-in screen or any other screen after deletion.
                } catch (e) {
                  // Handle errors here
                  print('Error deleting account: $e');
                  // You can display an error message to the user here
                }
              },
            ),
          ],
        );
      },
    );
  }

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
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              _showConfirmationDialog(context);
            },
            child: Text(
              'Delete Account',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
