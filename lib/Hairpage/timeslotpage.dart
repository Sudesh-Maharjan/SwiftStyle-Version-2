import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon/Hairpage/PopulateHairPage.dart';
import 'package:salon/CheckoutPages/Checkout.dart';

class TimeSlot {
  final String time;
  bool isBooked;
  bool isConfirming;

  TimeSlot({
    required this.time,
    this.isBooked = false,
    this.isConfirming = false,
  });
}

class TimeSlotPage extends StatefulWidget {
  final List<Service> selectedServices; // Pass selected services

  TimeSlotPage({
    required this.selectedServices,
  });

  @override
  _TimeSlotPageState createState() => _TimeSlotPageState();
}

class _TimeSlotPageState extends State<TimeSlotPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> bookedTimeSlots = [];

  @override
  void initState() {
    super.initState();
    loadBookedTimeSlots();
  }

  void loadBookedTimeSlots() {
    FirebaseFirestore.instance
        .collection('user_servicebookedinfo')
        .get()
        .then((querySnapshot) {
      final List<String> timeSlots = [];
      querySnapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final timeSlot = data['timeSlot'] as String;
        timeSlots.add(timeSlot);
      });

      setState(() {
        bookedTimeSlots = timeSlots;
      });
    });
  }

  final List<TimeSlot> timeSlots = List.generate(
    ((19 - 10) * 2) + 1,
    (index) {
      final hour = 10 + (index ~/ 2);
      final minute = (index % 2) * 30;
      final String period = hour < 12 ? 'AM' : 'PM';
      return TimeSlot(
        time:
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period',
      );
    },
  );

  void resetTimeSlotSelection(TimeSlot timeSlot) {
    setState(() {
      timeSlot.isBooked = false;
      timeSlot.isConfirming = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Select a Time Slot'),
      ),
      body: ListView.builder(
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          final timeSlot = timeSlots[index];
          final isTimeSlotBooked = bookedTimeSlots.contains(timeSlot.time);
          return ListTile(
            title: Text(timeSlot.time),
            trailing: ElevatedButton(
              onPressed:
                  isTimeSlotBooked || timeSlot.isBooked || timeSlot.isConfirming
                      ? null
                      : () {
                          setState(() {
                            timeSlot.isBooked = true;
                            timeSlot.isConfirming = false;
                          });
                          showConfirmationDialog(timeSlot);
                        },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.selectedServices.any(
                        (service) => service.isSelected && !timeSlot.isBooked)
                    ? Color.fromARGB(255, 0, 0, 2)
                    : Color.fromARGB(255, 62, 169, 158),
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(
                isTimeSlotBooked
                    ? 'Already Booked'
                    : timeSlot.isBooked
                        ? 'Selected'
                        : timeSlot.isConfirming
                            ? 'Confirm booking'
                            : 'Select',
              ),
            ),
          );
        },
      ),
    );
  }

  bool isBookingConfirmed = false;

  Future<void> showConfirmationDialog(TimeSlot timeSlot) async {
    double totalPrice = 0.0;
    for (var service in widget.selectedServices) {
      totalPrice += service.price;
    }

    final user = FirebaseAuth.instance.currentUser;
    final currentContext = context;
    showDialog(
      context: currentContext,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Booking Confirmation'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You have selected a time:'),
              SizedBox(height: 8),
              Text('Time: ${timeSlot.time}'),
              SizedBox(height: 8),
              Text('Selected Services:'),
              for (var service in widget.selectedServices)
                if (service.isSelected) Text('- ${service.name}'),
              SizedBox(height: 8),
              Text(
                'Total Price: $totalPrice',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                resetTimeSlotSelection(timeSlot);
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: isBookingConfirmed
                  ? null
                  : () async {
                      setState(() {
                        timeSlot.isBooked = true;
                        isBookingConfirmed = true;
                        timeSlot.isConfirming = false;
                      });

                      try {
                        await FirebaseFirestore.instance
                            .collection('user_servicebookedinfo')
                            .add({
                          'timeSlot': timeSlot.time,
                          'selectedServices': widget.selectedServices
                              .where((service) => service.isSelected)
                              .map((service) => service.name)
                              .toList(),
                          'totalPrice': totalPrice,
                        });

                        setState(() {
                          timeSlot.isBooked = true;
                          isBookingConfirmed = true;
                        });

                        Navigator.pop(currentContext);
                        final snackBar = SnackBar(
                          content: Text('You have selected a time slot'),
                          duration: Duration(seconds: 6),
                        );
                        ScaffoldMessenger.of(currentContext)
                            .showSnackBar(snackBar);
                      } catch (e) {
                        print('Error: $e');
                      }

                      // Navigate to the checkout page
                      Navigator.push(
                        currentContext,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(
                            selectedServices: widget.selectedServices
                                .where((service) => service.isSelected)
                                .toList(),
                            totalPrice: totalPrice,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(
                isBookingConfirmed ? 'Service Info saved' : 'Checkout',
              ),
            ),
          ],
        );
      },
    );
  }
}
