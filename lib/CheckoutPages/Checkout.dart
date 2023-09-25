import 'package:flutter/material.dart';

import '../Hairpage/hair.dart';

// import 'package:salon/Hairpage/timeslotpage.dart';
class CheckoutPage extends StatelessWidget {
  final List<String> selectedServices;
  final List<ServiceProvider> selectedProviders;
  final double totalPrice;

  CheckoutPage({
    required this.selectedServices,
    required this.selectedProviders,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Services:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            for (var service in selectedServices) ...[
              const SizedBox(height: 4),
              Text(
                '- $service',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
            const SizedBox(height: 8),
            const Text(
              'Selected Service Providers:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            for (var provider in selectedProviders) ...[
              SizedBox(height: 4),
              Text(
                '- ${provider.name}',
                style: TextStyle(fontSize: 16),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Total Price: $totalPrice',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text('Payment with Khalti'),
            ),
          ],
        ),
      ),
    );
  }
}
