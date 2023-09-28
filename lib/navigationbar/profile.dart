import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  // final TextEditingController firstNameController = TextEditingController();
  // final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // late String? firstName;
  // late String? lastName;
  bool isDataSaved = false;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();

    // Fetch local data if available
    fetchLocalData();

    // Fetch user profile data from Firestore
    fetchUserData().then((userData) {
      setState(() {
        phoneNumberController.text = userData['phoneNumber'] ?? '';
        dobController.text = userData['dateOfBirth'] ?? '';
        addressController.text = userData['address'] ?? '';
      });
    });
  }

  Future<void> fetchLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phoneNumberController.text = prefs.getString('phoneNumber') ?? '';
    dobController.text = prefs.getString('dateOfBirth') ?? '';
    addressController.text = prefs.getString('address') ?? '';
  }

  Future<void> saveLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phoneNumber', phoneNumberController.text);
    prefs.setString('dateOfBirth', dobController.text);
    prefs.setString('address', addressController.text);
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch user profile data from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('user_profile_data')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          return userData;
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return {};
  }

  Future<void> saveUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = {
          'email': user.email,
          'phoneNumber': phoneNumberController.text,
          'dateOfBirth': dobController.text,
          'address': addressController.text,
        };

        // Update user profile data in Firestore
        await FirebaseFirestore.instance
            .collection('user_profile_data')
            .doc(user.uid)
            .set(userData);

        // Show a success message or perform other actions
        setState(() {
          isDataSaved = true;
        });
        // Save data locally
        saveLocalData();
      }
    } catch (e) {
      print('Error saving user data: $e');
      // Handle errors here
    }
  }

  Future<void> _showConfirmationDialog() async {
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
                //current user firestore bata leko
                final user = FirebaseAuth.instance.currentUser;
                //delete account using Firebase Auth
                if (user != null) {
                  //null vayena vani matrai try block ma janxa
                  try {
                    //user lai delete gareko
                    await user.delete();
                    //user ko document delete gareko
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .delete();
                    //Signout farako
                    await FirebaseAuth.instance.signOut();

                    // Navigate to the login page using the global navigator
                    _navigatorKey.currentState?.pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(
                          onTap: () {},
                        ),
                      ),
                    );
                  } catch (e) {
                    // Handle errors here
                    print('Error deleting account: $e');
                  }
                }
                ;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Dispose of text controllers when done

    phoneNumberController.dispose();
    dobController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
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
                        backgroundImage: NetworkImage(
                            'https://example.com/profile_image.jpg'),
                      ),
                      const SizedBox(height: 16.0),
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
                      TextFormField(
                        controller: phoneNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: dobController,
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
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
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          saveUserData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.black, // Set the background color here
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      if (isDataSaved) // Display confirmation message when data is saved
                        const Text(
                          'Information has been saved.',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      _showConfirmationDialog();
                    },
                    child: Text(
                      'Delete Account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
