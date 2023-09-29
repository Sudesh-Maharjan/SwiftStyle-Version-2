import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salon/Businessaccountpages/BusinessAnotherPage.dart';

class NextPage extends StatelessWidget {
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController cityNameController = TextEditingController();
  final TextEditingController addressNameController = TextEditingController();
  final TextEditingController localityNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  late BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 188, 221, 226),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 102, 193, 207),
        title: const Text('Where Do You Work?'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Business:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: businessNameController,
                    decoration: InputDecoration(
                      hintText: 'Business Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'City:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: cityNameController,
                    decoration: InputDecoration(
                      hintText: 'City Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Address:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: addressNameController,
                    decoration: InputDecoration(
                      hintText: 'Address Name',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text, // Ensure text keyboard
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Locality:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: localityNameController,
                    decoration: InputDecoration(
                      hintText: 'Your Locality Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Phone Number:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: contactNumberController,
                    decoration: InputDecoration(
                      hintText: 'Your Contact Number(+977)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone, // yo Number keypad
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (validateFields()) {
                          //fire base ma info save garne
                          storeInformationInFirestore();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnotherPage(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 102, 193, 207),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateFields() {
    final String businessName = businessNameController.text;
    final String cityName = cityNameController.text;
    final String addressName = addressNameController.text;
    final String localityName = localityNameController.text;
    final String contactNumber = contactNumberController.text;

    final contactpattern = RegExp(r'^98\d{8}$');
    // final namePattern_business_next = RegExp(r'cd saon^(?!.*(.)\1{2})[a-zA-Z]+$');

    // Check if any field is empty
    if (businessName.isEmpty ||
        cityName.isEmpty ||
        addressName.isEmpty ||
        localityName.isEmpty ||
        contactNumber.isEmpty) {
      _showValidationError('All fields are required.');
      return false;
    }

    // Check for continuously repeating letters
    // if (!namePattern_business_next.hasMatch(businessName) ||

    //   _showValidationError(
    //       'Fields should not have continuously repeating letters.');
    //   return false;
    // }

    // Check if contact number follows the pattern
    if (!contactpattern.hasMatch(contactNumber)) {
      _showValidationError(
          'Phone Number should start with 98 and contain 10 digits.');
      return false;
    }

    // Check if fields have at least 3 characters (or numbers based on their type)
    if (businessName.length < 3 ||
        cityName.length < 3 ||
        addressName.length < 3 ||
        localityName.length < 3 ||
        contactNumber.length < 3) {
      _showValidationError(
          'All fields should have at least 3 characters/numbers.');
      return false;
    }
    // Check if fields have at least 3 characters (or numbers based on their type)
    if (businessName.length < 3 ||
        cityName.length < 3 ||
        addressName.length < 3 ||
        localityName.length < 3 ||
        contactNumber.length < 3) {
      _showValidationError(
          'All fields should have at least 3 characters/numbers.');
      return false;
    }

    return true;
  }

  bool containsNumbers(String text) {
    // Function to check if a string contains numbers
    return RegExp(r'\d').hasMatch(text);
  }

  void _showValidationError(String message) {
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Validation Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void storeInformationInFirestore() {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String businessName = businessNameController.text;
    final String cityName = cityNameController.text;
    final String addressName = addressNameController.text;
    final String localityName = localityNameController.text;
    final String contactNumber = contactNumberController.text;

    // Create a map with the information
    final Map<String, dynamic> businessInfo = {
      'businessName': businessName,
      'cityName': cityName,
      'addressName': addressName,
      'localityName': localityName,
      'contactNumber': contactNumber,
    };

    // Add this information to the Firestore collection
    firestore.collection('business_user_work_info').add(businessInfo);
    businessNameController.clear();
    cityNameController.clear();
    addressNameController.clear();
    localityNameController.clear();
    contactNumberController.clear();
  }
}
