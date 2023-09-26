import 'package:flutter/material.dart';
import 'package:salon/Businessaccountpages/BusinessPage2.dart';

class AnotherPage extends StatefulWidget {
  @override
  _AnotherPageState createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  List<Map<String, String>> services = [];

  TextEditingController serviceNameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void addService() {
    setState(() {
      services.add({
        'serviceName': serviceNameController.text,
        'duration': durationController.text,
        'price': priceController.text,
        'description': descriptionController.text,
      });

      serviceNameController.clear();
      durationController.clear();
      priceController.clear();
      descriptionController.clear();
    });

    // Show a dialog with service details
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 166, 217, 226),
          title: const Text(
            'Service Added',
            style: TextStyle(fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Service Name: ${serviceNameController.text}'),
              Text('Duration: ${durationController.text}'),
              Text('Price: ${priceController.text}'),
              Text('Description: ${descriptionController.text}'),
            ],
          ),
          actions: [
            Container(
              padding: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 6, 1, 1), // Set the color of the box around "OK"
                borderRadius:
                    BorderRadius.circular(5.0), // Set border radius if desired
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  primary: Colors.white, // Change the color of the "OK" text
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void navigateToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Page2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 188, 221, 226),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 102, 193, 207),
        title: const Text('Enlist Your Services'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTextField('Service Name', serviceNameController),
            _buildTextField('Duration (e.g. 30 minutes)', durationController),
            _buildTextField('Price (e.g. \$50)', priceController),
            _buildTextField('Description', descriptionController),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 102, 193, 207),
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
                      title: Text('Service: ${services[index]['serviceName']}'),
                      subtitle: Text(
                        'Duration: ${services[index]['duration']}\nPrice: ${services[index]['price']}\nDescription: ${services[index]['description']}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
      const SizedBox(height: 16.0),
    ],
  );
}

void main() {
  runApp(MaterialApp(
    home: AnotherPage(),
  ));
}
