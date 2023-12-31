import 'package:flutter/material.dart';
import 'package:salon/Hairpage/PopulateHairPage.dart'; // You may need to import this
import 'package:salon/Khalit/Khalti_payment_gateway.dart';

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
  // bool payOfflineSelected = false;
  bool payWithKhaltiSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.black, // Set appbar color to black
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selected Services:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              // Display the selected services and total price
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.selectedServices.map((service) {
                  return Text(
                    '- ${service.name}',
                    style: const TextStyle(fontSize: 18),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                'Total Price: \$${widget.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold), // Bold the total price
              ),
              const SizedBox(height: 32),
              const Text(
                'Payment Options:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Payment with Khalti button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // payOfflineSelected = false;
                    payWithKhaltiSelected = true;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KhaltiPaymentPage(
                        totalPrice: widget.totalPrice,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 154, 45, 173),
                ),
                child: const Text(
                  'Payment with Khalti',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
