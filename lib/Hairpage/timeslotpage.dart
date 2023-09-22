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
  final String serviceName;
  final ServiceProvider
      serviceProvider; //hair page ko serviceprovide ko name yeta recieve hunxa

  TimeSlotPage(
      {required this.serviceName,
      required this.serviceProvider,
      required List<String> selectedServices,
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
    serviceName = widget.serviceName;
    serviceProviderName = widget.serviceProvider.name;
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
    );
  }

  void showConfirmationDialog(TimeSlot timeSlot) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Booking Confirmation'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You have selected a time slot:'),
              SizedBox(height: 8),
              Text('Time: ${timeSlot.time}'),
              SizedBox(height: 8),
              Text('Service Name: $serviceName'), // Display the service name
              SizedBox(height: 8),
              Text(
                  'Service Provider: $serviceProviderName'), // Display the provider name
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
