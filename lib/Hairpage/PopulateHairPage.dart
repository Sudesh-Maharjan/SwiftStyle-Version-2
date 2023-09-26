import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  static Future<List<Service>> fetchHairServices() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('service_added_data')
              .get();

      final List<Service> services = await Future.wait(
        snapshot.docs.map((doc) async {
          final data = doc.data();
          final serviceProviderId = data['serviceProviderId'] ?? '';

          // Fetch service provider data
          final serviceProviderDoc = await FirebaseFirestore.instance
              .collection('businesses_user_info')
              .doc(serviceProviderId)
              .get();

          final serviceProviderData = serviceProviderDoc.data();
          final serviceProviderName = serviceProviderData != null
              ? '${serviceProviderData['FirstName'] ?? ''} ${serviceProviderData['LastName'] ?? ''}'
              : '';

          return Service(
            serviceName: data['serviceName'] ?? '',
            price: data['price'] ?? 0,
            serviceProviderId: serviceProviderId,
            serviceProviderName: serviceProviderName,
          );
        }),
      );

      return services;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}

class Service {
  String serviceName;
  int price;
  String serviceProviderId;
  String serviceProviderName;

  Service({
    required this.serviceName,
    required this.price,
    required this.serviceProviderId,
    this.serviceProviderName = '',
  });
}
