import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon/Hairpage/PopulateHairPage.dart';

class CheckoutPage extends StatefulWidget {
  final List<Service> selectedServices; // Selected services
  final double totalPrice; // Total price of selected services
  CheckoutPage({
    required this.selectedServices,
    required this.totalPrice,
  });
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Future<List<Map<String, dynamic>>> bookings;

  @override
  void initState() {
    super.initState();
    bookings = fetchBookings();
  }

  Future<List<Map<String, dynamic>>> fetchBookings() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('user_servicebookedinfo')
            .get();

    final List<Map<String, dynamic>> bookings = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      final Map<String, dynamic> data = doc.data();
      bookings.add(data);
    }

    return bookings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bookings:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: bookings,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No bookings found.');
                  } else {
                    final List<Map<String, dynamic>> bookingData =
                        snapshot.data!;
                    return ListView.builder(
                      itemCount: bookingData.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> booking = bookingData[index];
                        return BookingCard(booking: booking);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;

  BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Slot: ${booking['timeSlot']}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Selected Services:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (booking['selectedServices'] as List<dynamic>)
                  .map<Widget>((service) {
                return Text(
                  '- $service',
                  style: TextStyle(fontSize: 14),
                );
              }).toList(),
            ),
            SizedBox(height: 8),
            Text(
              'Total Price: \$${booking['totalPrice'].toStringAsFixed(2)}',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
