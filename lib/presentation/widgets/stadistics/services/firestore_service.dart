import 'package:cloud_firestore/cloud_firestore.dart';

// Función para obtener los clientes frecuentes
Future<List<Map<String, dynamic>>> getFrequentClients() async {
  final appointmentsSnapshot =
      await FirebaseFirestore.instance.collection('appointments').get();

  Map<String, int> clientCounts = {};

  // Contar las citas por cliente
  for (var doc in appointmentsSnapshot.docs) {
    final clientId = doc['client_id'];
    if (clientCounts.containsKey(clientId)) {
      clientCounts[clientId] = clientCounts[clientId]! + 1;
    } else {
      clientCounts[clientId] = 1;
    }
  }

  List<Map<String, dynamic>> frequentClients = [];

  for (var clientId in clientCounts.keys) {
    final clientSnapshot = await FirebaseFirestore.instance
        .collection('clients')
        .doc(clientId)
        .get();

    if (clientSnapshot.exists) {
      final clientData = clientSnapshot.data()!;
      frequentClients.add({
        'name': clientData['name'],
        'phone': clientData['phone'],
        'address': clientData['address'],
        'appointmentsCount': clientCounts[clientId],
      });
    }
  }

  frequentClients
      .sort((a, b) => b['appointmentsCount'].compareTo(a['appointmentsCount']));

  return frequentClients;
}

// Función para obtener las citas de un cliente específico
Future<List<Map<String, dynamic>>> getClientAppointments(
    String clientId) async {
  final appointmentsSnapshot = await FirebaseFirestore.instance
      .collection('appointments')
      .where('client_id', isEqualTo: clientId)
      .get();

  List<Map<String, dynamic>> appointments = [];

  for (var doc in appointmentsSnapshot.docs) {
    final appointmentData = doc.data();
    appointments.add({
      'date':
          appointmentData['date'].toDate(), // Convertimos la fecha a DateTime
      'status': appointmentData['status'],
    });
  }

  return appointments;
}
