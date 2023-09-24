import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon/Hairpage/hair.dart';

class TimeSlot {
  final String time;
  bool isBooked;
  ServiceProvider? serviceProvider;

  TimeSlot({
    required this.time,
    this.isBooked = false,
    this.serviceProvider,
  });
}

class TimeSlotPage extends StatefulWidget {
  // final String serviceName;
  // final ServiceProvider
  //     serviceProvider; //hair page ko serviceprovide ko name yeta recieve hunxa
  final List<String> selectedServices; // List to store selected service names
  final List<ServiceProvider> selectedProviders;
  TimeSlotPage(
      {
      // required this.serviceName,
      // required this.serviceProvider,
      required this.selectedProviders,
      required this.selectedServices,
      ServiceProvider? selectedProvider});

  @override
  _TimeSlotPageState createState() => _TimeSlotPageState();
}

class _TimeSlotPageState extends State<TimeSlotPage> {
  String serviceName = ''; // Instance variable to store service name
  String serviceProviderName = ''; // Instance variable to store provider name

  @override
  void initState() {
    super.initState();
    // Initialize the instance variables with the values from the widget properties
    serviceName = widget.selectedServices.join(', ');
    serviceProviderName =
        widget.selectedProviders.map((p) => p.name).join(', ');
  }

  final List<TimeSlot> timeSlots = List.generate(
    ((19 - 10) * 2) +
        1, // Calculate the number of time slots (8:00 AM to 7:30 PM)
    (index) {
      final hour =
          10 + (index ~/ 2); // Calculate the hour (10, 10, 11, 11, 12, 12, ...)
      final minute =
          (index % 2) * 30; // Calculate the minute (0, 30, 0, 30, 0, 30, ...)
      final String period = hour < 12 ? 'AM' : 'PM';
      return TimeSlot(
          time:
              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period');
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Select a Time Slot'),
      ),
      body: ListView.builder(
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          final timeSlot = timeSlots[index];
          return ListTile(
            title: Text(timeSlot.time),
            trailing: timeSlot.isBooked
                ? Text('Booked')
                : ElevatedButton(
                    onPressed: timeSlot.isBooked
                        ? null
                        : () {
                            // Handle booking logic here
                            // You can set timeSlot.isBooked to true and assign the serviceProvider
                            // Once booked, you should update the UI accordingly
                            setState(() {
                              timeSlot.isBooked = true;
                              timeSlot.serviceProvider =
                                  getAvailableServiceProvider();
                            });

                            // Show a confirmation dialog or navigate to a confirmation page
                            showConfirmationDialog(timeSlot);
                          },
                    style: ElevatedButton.styleFrom(
                      // Check if the selected services contain the service related to this time slot
                      // If it does, set the button color to red, otherwise, keep it green
                      backgroundColor: widget.selectedServices
                              .contains(timeSlot.serviceProvider?.name ?? '')
                          ? Colors.red
                          : Color.fromARGB(255, 62, 169, 158),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Book'),
                  ),
          );
        },
      ),
    );
  }

  ServiceProvider? getAvailableServiceProvider() {
    // Implement your logic to get an available service provider
    // This can be based on your business rules or availability
    return ServiceProvider(
      name: 'Selected Provider',
      description: 'Provider Description',
      profileImage: 'Provider Image URL',
      price: 100,
    );
  }

  bool isBookingConfirmed = false; // Track booking confirmation status
  Future<void> showConfirmationDialog(TimeSlot timeSlot) async {
    // Calculate the total price
    double totalPrice = 0.0;
    for (var pricee in widget.selectedProviders) {
      totalPrice += pricee.price;
    }
    // Get the user's name from Firebase Authentication
    final user = FirebaseAuth.instance.currentUser;
    final userName = user != null ? user.displayName : 'Unknown User';

    showDialog(
      context: context,
      builder: (context) {
        //yo data firebase ma store garna ko lagi

        return AlertDialog(
          title: Text('Booking Confirmation'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You have selected a time:'),
              SizedBox(height: 8),
              Text('Time: ${timeSlot.time}'),
              SizedBox(height: 8),
              Text('Selected Services:'),
              for (var service in widget.selectedServices) ...[
                SizedBox(height: 4),
                Text('- $service'),
              ], // Display the provider name
              SizedBox(height: 8),
              Text('Selected Service Providers:'),
              for (var provider in widget.selectedProviders) ...[
                SizedBox(height: 4),
                Text('- ${provider.name}'),
              ],
              SizedBox(
                height: 8,
              ),
              Text('Price:'),
              for (var pricee in widget.selectedProviders) ...[
                Text('- ${pricee.price}'),
              ],
              SizedBox(
                height: 8,
              ),
              Text(
                'Total Price: $totalPrice',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              //Total price
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: isBookingConfirmed
                  ? null
                  : () async {
                      // Handle booking confirmation logic here
                      // Mark the time slot as booked and assign the service provider
                      setState(() {
                        timeSlot.isBooked = true;
                        timeSlot.serviceProvider =
                            getAvailableServiceProvider();
                        isBookingConfirmed = true;
                      });

                      //datastore in firestore yeta
                      try {
                        await FirebaseFirestore.instance
                            .collection('user_servicebookedinfo')
                            .add({
                          'UserName': userName,
                          'timeSlot': timeSlot.time,
                          'selectedServices': widget.selectedServices,
                          'selectedProviders': widget.selectedProviders
                              .map((p) => p.name)
                              .toList(),
                          'totalPrice': totalPrice,
                          // Add any other relevant data you want to store
                        });

                        setState(() {
                          timeSlot.isBooked = true;
                          timeSlot.serviceProvider =
                              getAvailableServiceProvider();
                          isBookingConfirmed = true;
                        });

                        Navigator.pop(context); // Close the dialog
                      } catch (e) {
                        // Handle errors
                        print('Error: $e');
                        // You can show an error message to the user or handle the error in another way
                      }
                      Navigator.pop(context); // Close the dialog
                    },
              style: ElevatedButton.styleFrom(
                // Customize the button style
                backgroundColor: Colors.green, // Change the button color
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(
                isBookingConfirmed ? 'Booking Confirmed' : 'Confirm Booking',
              ), // Button label
            ),
          ],
        );
      },
    );
  }
}
