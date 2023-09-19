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

  TimeSlotPage({required this.serviceName});

  @override
  _TimeSlotPageState createState() => _TimeSlotPageState();
}

class _TimeSlotPageState extends State<TimeSlotPage> {
  final List<TimeSlot> timeSlots = List.generate(
    8,
    (index) => TimeSlot(time: '${10 + index}:00 AM'),
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
              Text(
                  'Service Provider: ${timeSlot.serviceProvider?.name ?? 'N/A'}'),
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
