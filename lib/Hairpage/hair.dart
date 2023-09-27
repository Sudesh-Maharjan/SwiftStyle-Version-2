import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salon/Hairpage/timeslotpage.dart';

class Service {
  final String name;
  final String description;
  final int price;
  Service({
    required this.name,
    required this.description,
    required this.price,
  });
}

class HairPage extends StatefulWidget {
  @override
  State<HairPage> createState() => _HairPageState();
}

class _HairPageState extends State<HairPage> {
  List<Service> hairdynamic = [];
  late TimeSlot selectedTimeSlot;
  List<String> selectedServices = [];
  List<ServiceProvider> selectedProviders = [];
  Map<String, ServiceProvider?> selectedProviderMap = {};

  // Initialize Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to fetch data from Firestore
  Future<void> fetchServiceData() async {
    try {
      final querySnapshot =
          await _firestore.collection('service_added_data').get();
      final services = querySnapshot.docs.map((doc) {
        final serviceNames = doc['serviceName'] as String;
        final description = doc['description'] as String;
        final price = doc['price'];

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
            name: serviceNames, description: description, price: parsedPrice);
      }).toList();
      setState(() {
        hairdynamic = services;
      });
    } catch (e) {
      print("Error fetching data: $e");
      throw e; // throws exception error lai indicate garauna
    }
  }

  @override
  void initState() {
    super.initState();
    fetchServiceData();
    selectedTimeSlot = TimeSlot(
      time: 'Default Time',
      isBooked: false,
      serviceProvider: null,
    );
  }

//product selection and deselection ko lagi
  void toggleSelection(
      ServiceProvider provider, String service, bool isSelected) {
    setState(() {
      if (isSelected) {
        if (selectedProviderMap.containsKey(service)) {
          selectedProviderMap.remove(service); //service deselect
        } else {
          selectedProviderMap[service] = provider; // service select
        }
      }
      // Update isSelected property provider ko
      provider.isSelected = selectedProviderMap.containsKey(service);

      // Update selectedProviders and selectedServices
      selectedProviders.clear();
      selectedServices.clear();

      for (final entry in selectedProviderMap.entries) {
        final service = entry.key;
        final provider = entry.value;

        if (provider != null) {
          selectedProviders.add(provider);
          selectedServices.add(service);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Hair Services'),
      ),
      body: ListView.builder(
        itemCount: hairdynamic.length,
        itemBuilder: (context, index) {
          final service = hairdynamic[index];
          final serviceProviders = getServiceProviders(service.name);

          if (serviceProviders.isEmpty) {
            selectedTimeSlot = TimeSlot(
              time: 'Default time',
              isBooked: false,
              serviceProvider: null,
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: serviceProviders.map((provider) {
                      final isSelected = selectedProviders.contains(provider) &&
                          selectedServices.contains(service);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          elevation: isSelected ? 5 : 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            // Apply different background colors or borders based on isSelected
                            side: isSelected
                                ? const BorderSide(
                                    color: Colors.green, // Selected color
                                    width: 2.0,
                                  )
                                : BorderSide.none, // No border for unselected
                          ),
                          child: CheckboxListTile(
                            value: provider.isSelected,
                            onChanged: (bool? newValue) {
                              toggleSelection(
                                  provider, service.name, newValue!);
                            },
                            title: Text(
                              provider.name,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                // Apply different text styles based on isSelected
                                color: isSelected ? Colors.green : Colors.black,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.description,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.green
                                        : Colors.black,
                                  ),
                                ),
                                Text(
                                  'Price: \$${provider.price}',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.green
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            secondary: isSelected
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Handle the "Next" button press if needed
              final selectedProvidersList = selectedProviderMap.values
                  .where((provider) => provider != null)
                  .cast<ServiceProvider>()
                  .toList();
              if (selectedProvidersList.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimeSlotPage(
                      // serviceName: selectedServices,
                      selectedServices: selectedServices,
                      selectedProviders: selectedProvidersList,
                    ),
                  ),
                );
              } else {
                //Show msg or prevent navigation if no services are selected
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                textStyle: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            child: const Text(
              'Next',
            ),
          ),
        ),
      ),
    );
  }
}

List<ServiceProvider> getServiceProviders(String category) {
  if (category == "Haircut") {
    return [
      ServiceProvider(
        name: "Sudesh Maharjan",
        description: "Expert in trendy haircuts",
        profileImage: "https://example.com/john_doe_profile.jpg",
        price: 150,
      ),
      ServiceProvider(
        name: "Jane Smith",
        description: "Specializes in men's haircuts",
        profileImage: "https://example.com/jane_smith_profile.jpg",
        price: 200,
      ),
    ];
  } else if (category == "Hair Styling") {
    return [
      ServiceProvider(
        name: "Emily Johnson",
        description: "Creates stunning hairstyles",
        profileImage: "https://example.com/emily_johnson_profile.jpg",
        price: 100,
      ),
    ];
  } else if (category == "Hair Coloring") {
    return [
      ServiceProvider(
        name: "Michael Brown",
        description: "Master of hair coloring techniques",
        profileImage: "https://example.com/michael_brown_profile.jpg",
        price: 150,
      ),
      ServiceProvider(
        name: "Sophia Davis",
        description: "Offers creative hair coloring solutions",
        profileImage: "https://example.com/sophia_davis_profile.jpg",
        price: 200,
      ),
    ];
  } else if (category == "Hair Extensions") {
    return [
      ServiceProvider(
        name: "William Wilson",
        description: "Specializes in hair extensions",
        profileImage: "https://example.com/william_wilson_profile.jpg",
        price: 250,
      ),
      ServiceProvider(
        name: "Olivia Martinez",
        description: "Provides high-quality hair extensions",
        profileImage: "https://example.com/olivia_martinez_profile.jpg",
        price: 300,
      ),
    ];
  }

  return [];
}

class ServiceProvider {
  final String name;
  final String description;
  final String profileImage;
  bool isSelected;
  final int price;

  ServiceProvider({
    required this.name,
    required this.description,
    required this.profileImage,
    this.isSelected = false,
    required this.price,
  });

  get serviceProvider => null;

  get serviceName => null;

  get services => null;
}
