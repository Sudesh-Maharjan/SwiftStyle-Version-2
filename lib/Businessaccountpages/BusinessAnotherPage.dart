import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salon/Businessaccountpages/BusinessPage2.dart';

class AnotherPage extends StatefulWidget {
  @override
  _AnotherPageState createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  List<Map<String, String?>> services = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController serviceNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String? selectedDuration = "30 minutes";
  TextEditingController descriptionController = TextEditingController();

  void addService() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        services.add({
          'serviceName': serviceNameController.text,
          'duration': selectedDuration,
          'price': priceController.text,
          'description': descriptionController.text,
        });

        serviceNameController.clear();
        priceController.clear();
        descriptionController.clear();
        selectedDuration = "30 minutes";
      });
      storeServicesInFirestore();
    }
  }

  void navigateToNextPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Page2()),
    );
  }

  void storeServicesInFirestore() {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    for (final service in services) {
      firestore.collection('service_added_data').add({
        'serviceName': service['serviceName'],
        'duration': service['duration'],
        'price': service['price'],
        'description': service['description'],
      });
    }
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
              _buildTextField('Service Name', serviceNameController),
              _buildDropdownField('Duration', selectedDuration),
              _buildNumericTextField('Price (e.g. \$50)', priceController),
              _buildTextField('Description', descriptionController),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 102, 193, 207),
                ),
                onPressed: addService,
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
                          'Duration: ${services[index]['duration'] ?? 'N/A'}\nPrice: ${services[index]['price'] ?? 'N/A'}\nDescription: ${services[index]['description'] ?? 'N/A'}',
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
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToNextPage,
        tooltip: 'Go to Next Page',
        child: const Icon(Icons.arrow_forward),
        backgroundColor: const Color.fromARGB(255, 102, 193, 207),
      ),
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

  Widget _buildDropdownField(String label, String? value) {
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
                selectedDuration = newValue;
              });
            },
            items: <String>['30 minutes']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
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
