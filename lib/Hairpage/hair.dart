import 'package:flutter/material.dart';
import 'package:salon/Hairpage/timeslotpage.dart';

class HairPage extends StatefulWidget {
  @override
  State<HairPage> createState() => _HairPageState();
}

class _HairPageState extends State<HairPage> {
  final List<String> hairServices = [
    "Haircut",
    "Hair Styling",
    "Hair Coloring",
    "Hair Extensions",
  ];
  late TimeSlot selectedTimeSlot;
  ServiceProvider selectedProvider =
      ServiceProvider(name: '', description: '', profileImage: '');
  String selectedService = '';
  List<String> selectedServices = [];
  @override
  void initState() {
    super.initState();
    selectedTimeSlot = TimeSlot(
      time: 'Default Time',
      isBooked: false,
      serviceProvider: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Hair Services'),
      ),
      body: ListView.builder(
        itemCount: hairServices.length,
        itemBuilder: (context, index) {
          final service = hairServices[index];
          final serviceProviders = getServiceProviders(service);

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
                      service,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: serviceProviders.map((provider) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(provider.profileImage),
                            ),
                            title: Text(provider.name),
                            subtitle: Text(provider.description),
                            trailing: ElevatedButton(
                              onPressed: selectedTimeSlot.isBooked
                                  ? null
                                  : () {
                                      setState(() {
                                        selectedTimeSlot = TimeSlot(
                                          time: 'Selected Time',
                                          isBooked: true,
                                          serviceProvider: provider,
                                        );
                                        selectedService = service;
                                        selectedProvider = provider;
                                      });
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => TimeSlotPage(
                                      //       serviceName: selectedService,
                                      //       serviceProvider: selectedProvider,
                                      //       selectedServices: selectedServices,
                                      //     ),
                                      //   ),
                                      // );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 62, 169, 158),
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: Text('Select'),
                            ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimeSlotPage(
                    serviceName: selectedService,
                    serviceProvider: selectedProvider,
                    selectedServices: selectedServices,
                  ),
                ),
              );
            },
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
      ),
      ServiceProvider(
        name: "Jane Smith",
        description: "Specializes in men's haircuts",
        profileImage: "https://example.com/jane_smith_profile.jpg",
      ),
    ];
  } else if (category == "Hair Styling") {
    return [
      ServiceProvider(
        name: "Emily Johnson",
        description: "Creates stunning hairstyles",
        profileImage: "https://example.com/emily_johnson_profile.jpg",
      ),
    ];
  } else if (category == "Hair Coloring") {
    return [
      ServiceProvider(
        name: "Michael Brown",
        description: "Master of hair coloring techniques",
        profileImage: "https://example.com/michael_brown_profile.jpg",
      ),
      ServiceProvider(
        name: "Sophia Davis",
        description: "Offers creative hair coloring solutions",
        profileImage: "https://example.com/sophia_davis_profile.jpg",
      ),
    ];
  } else if (category == "Hair Extensions") {
    return [
      ServiceProvider(
        name: "William Wilson",
        description: "Specializes in hair extensions",
        profileImage: "https://example.com/william_wilson_profile.jpg",
      ),
      ServiceProvider(
        name: "Olivia Martinez",
        description: "Provides high-quality hair extensions",
        profileImage: "https://example.com/olivia_martinez_profile.jpg",
      ),
    ];
  }

  return [];
}

class ServiceProvider {
  final String name;
  final String description;
  final String profileImage;

  ServiceProvider({
    required this.name,
    required this.description,
    required this.profileImage,
  });
}
