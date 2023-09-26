import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController businessNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Business'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: businessNameController,
                decoration: InputDecoration(labelText: 'Business Name'),
              ),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: localityController,
                decoration: InputDecoration(labelText: 'Locality'),
              ),
              SizedBox(height: 20.0),
              Text('Services', style: TextStyle(fontSize: 18.0)),
              TextFormField(
                controller: serviceNameController,
                decoration: InputDecoration(labelText: 'Service Name'),
              ),
              TextFormField(
                controller: durationController,
                decoration: InputDecoration(labelText: 'Duration'),
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Save the edited information
                  print('Edited Business Name: ${businessNameController.text}');
                  print('Edited City: ${cityController.text}');
                  print('Edited Address: ${addressController.text}');
                  print('Edited Locality: ${localityController.text}');
                  print('Edited Service Name: ${serviceNameController.text}');
                  print('Edited Duration: ${durationController.text}');
                  print('Edited Price: ${priceController.text}');
                  print('Edited Description: ${descriptionController.text}');
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
