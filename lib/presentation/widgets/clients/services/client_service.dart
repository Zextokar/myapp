import 'package:cloud_firestore/cloud_firestore.dart';

class ClientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> loadAppointments(String clientId) async {
    final appointmentsSnapshot = await _firestore
        .collection('appointments')
        .where('client_id', isEqualTo: clientId)
        .get();

    return appointmentsSnapshot.docs.map((doc) {
      final data = doc.data();
      final timestamp = data['date'] as Timestamp;
      final appointmentDate = DateTime(
        timestamp.toDate().year,
        timestamp.toDate().month,
        timestamp.toDate().day,
      );

      return {
        'id': doc.id,
        'date':
            '${appointmentDate.day.toString().padLeft(2, '0')}/${appointmentDate.month.toString().padLeft(2, '0')}/${appointmentDate.year}',
        'status': data['status'],
      };
    }).toList();
  }

  Future<void> addAppointment(String clientId, DateTime date) async {
    await _firestore.collection('appointments').add({
      'client_id': clientId,
      'date': date,
      'status': 'booked',
    });
  }

  Future<void> updateClient(
    String clientId,
    String name,
    String address,
    String phone,
  ) async {
    await _firestore.collection('clients').doc(clientId).update({
      'name': name,
      'address': address,
      'phone': phone,
    });
  }

  Future<void> deleteClient(String clientId) async {
    await _firestore.collection('clients').doc(clientId).delete();
  }
}
