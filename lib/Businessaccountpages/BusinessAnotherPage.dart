import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salon/Businessaccountpages/BusinessPage2.dart';

final List<String> serviceOptions = [
  'Hair Cutting',
  'Hair Coloring',
  'Hair Styling'
];

class AnotherPage extends StatefulWidget {
  @override
  _AnotherPageState createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  List<Map<String, String?>> services = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController priceController = TextEditingController();
  TextEditingController serviceProviderNameController = TextEditingController();
  String? selectedDuration = "30 minutes";
  String? selectedService;
  TextEditingController descriptionController = TextEditingController();
  bool dataSubmitted = false;

  void addService(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      setState(() {
        services.add({
          'serviceName': selectedService,
          'duration': selectedDuration,
          'price': priceController.text,
          'description': descriptionController.text,
          'serviceProviderName': serviceProviderNameController.text,
        });

        selectedService = null;
        priceController.clear();
        descriptionController.clear();
        serviceProviderNameController.clear();
        selectedDuration = "30 minutes";
        dataSubmitted = true;
      });
      if (dataSubmitted) {
        storeServicesInFirestore(context);
      }
    }
  }

  Future<void> storeServicesInFirestore(BuildContext context) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    for (final service in services) {
      await firestore.collection('service_added_data').add({
        'serviceName': service['serviceName'],
        'duration': service['duration'],
        'price': service['price'],
        'description': service['description'],
        'serviceProviderName': service['serviceProviderName'],
      });
    }
    // Show the success alert service add garexe
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Your service has been added.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void navigateToNextPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Page2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Solve bottom overflow issue
      backgroundColor: const Color.fromARGB(255, 188, 221, 226),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 102, 193, 207),
        title: const Text('Enlist Your Services'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDropdownField(
                  'Service Name', selectedService, serviceOptions),
              _buildTextField(
                  'Service Providers Name', serviceProviderNameController),
              _buildDropdownField('Duration', selectedDuration, ['30 minutes']),
              _buildNumericTextField('Price (e.g. \$50)', priceController),
              _buildTextField('Description', descriptionController),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 102, 193, 207),
                ),
                onPressed: () => addService(context),
                child: const Text(
                  'Add Service',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title:
                            Text('Service: ${services[index]['serviceName']}'),
                        subtitle: Text(
                          'Provider: ${services[index]['serviceProviderName'] ?? 'N/A'}\nDuration: ${services[index]['duration'] ?? 'N/A'}\nPrice: ${services[index]['price'] ?? 'N/A'}\nDescription: ${services[index]['description'] ?? 'N/A'}',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: navigateToNextPage,
      //   tooltip: 'Go to Next Page',
      //   child: Icon(Icons.arrow_forward),
      //   backgroundColor: const Color.fromARGB(255, 102, 193, 207),
      // ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 240, 244, 244),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildNumericTextField(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 240, 244, 244),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number, // Numeric keyboard
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildDropdownField(
      String label, String? value, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 240, 244, 244),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            onChanged: (newValue) {
              setState(() {
                selectedService = newValue;
              });
            },
            items: options.map<DropdownMenuItem<String>>((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AnotherPage(),
  ));
}
