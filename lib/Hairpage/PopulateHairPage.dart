import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salon/Hairpage/timeslotpage.dart';

class Service {
  final String name;
  final String description;
  final int price;
  final String serviceProviderName;
  bool isSelected;
  Service({
    required this.name,
    required this.description,
    required this.price,
    required this.serviceProviderName,
    this.isSelected = false,
  });
}

class HairPagepopulation extends StatefulWidget {
  @override
  State<HairPagepopulation> createState() => _HairPagepopulationState();
}

class _HairPagepopulationState extends State<HairPagepopulation> {
  List<Service> hairdynamic = [];
  bool isButtonEnabled = false;

  // Initialize Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchServiceData();
  }

  Future<void> fetchServiceData() async {
    try {
      final querySnapshot =
          await _firestore.collection('service_added_data').get();
      final services = querySnapshot.docs.map((doc) {
        final serviceNames = doc['serviceName'] as String;
        final description = doc['description'] as String;
        final price = doc['price'];
        final serviceProviderName = doc['serviceProviderName'] as String;

        int parsedPrice = 0;
        if (price is int) {
          parsedPrice = price;
        } else if (price is String) {
          final int? parsedInt = int.tryParse(price);
          if (parsedInt != null) {
            parsedPrice = parsedInt;
          }
        }

        return Service(
            name: serviceNames,
            description: description,
            price: parsedPrice,
            serviceProviderName: serviceProviderName);
      }).toList();
      setState(() {
        hairdynamic = services;
      });
    } catch (e) {
      print("Error fetching data: $e");
      throw e;
    }
  }

  // Function to handle selecting/deselecting a service
  void toggleServiceSelection(int index) {
    setState(() {
      hairdynamic[index].isSelected = !hairdynamic[index].isSelected;
      isButtonEnabled = hairdynamic.any((service) => service.isSelected);
    });
  }

  // Function to get selected services
  List<Service> getSelectedServices() {
    return hairdynamic.where((service) => service.isSelected).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Hair Services'),
      ),
      body: ListView.builder(
        itemCount: hairdynamic.length,
        itemBuilder: (context, index) {
          final service = hairdynamic[index];
          return ServiceCard(
            service: service,
            onSelected: () {
              toggleServiceSelection(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: isButtonEnabled
            ? () {
                List<Service> selectedServices = getSelectedServices();
                // Navigate to the next page ani pass selected services ko data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TimeSlotPage(selectedServices: selectedServices),
                  ),
                );
              }
            : null,
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final Service service;
  final VoidCallback onSelected;

  ServiceCard({
    required this.service,
    required this.onSelected,
  });

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    final textColor = widget.service.isSelected ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          widget.onSelected();
        },
        child: Card(
          color: widget.service.isSelected ? Colors.black : null,
          elevation: widget.service.isSelected ? 8.0 : 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service.name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  widget.service.description,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  "Price: \$${widget.service.price.toString()}",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  widget.service.serviceProviderName,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
