import 'package:flutter/material.dart';

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

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              // elevation: 4,
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
                    //Map function le service providers ko list lai widget ma convert garna halp garxa
                    //ani each of the provider in serviceproviders list lai chai Widget create garxa

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
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Booking Confirmation'),
                                      content: Text(
                                        'You have selected ${provider.name}. Do you want to proceed with the booking?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); // Close the dialog
                                            // Perform the booking action
                                            // Add your booking logic here
                                          },
                                          child: Text('Book'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); // Close the dialog
                                          },
                                          child: Text('Cancel'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 62, 169, 158),
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: Text('Book'),
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
