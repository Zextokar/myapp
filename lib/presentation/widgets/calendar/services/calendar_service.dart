import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<DateTime, List<Map<String, dynamic>>>> loadAppointments() async {
    final appointmentsSnapshot =
        await _firestore.collection('appointments').get();
    final clientsSnapshot = await _firestore.collection('clients').get();

    // Mapear client_id a nombres
    final clientsMap = {
      for (var client in clientsSnapshot.docs)
        client.id: client['name'] ?? 'Sin nombre',
    };

    // Procesar citas
    final appointmentsData = appointmentsSnapshot.docs.map((doc) {
      final data = doc.data();
      final clientName = clientsMap[data['client_id']] ?? 'Cliente desconocido';
      final timestamp = data['date'] as Timestamp;
      final appointmentDate = DateTime(
        timestamp.toDate().year,
        timestamp.toDate().month,
        timestamp.toDate().day,
      );

      return {
        'id': doc.id,
        'date': appointmentDate,
        'time':
            "${timestamp.toDate().hour.toString().padLeft(2, '0')}:${timestamp.toDate().minute.toString().padLeft(2, '0')}",
        'status': data['status'],
        'client_name': clientName,
      };
    }).toList();

    // Agrupar citas por fecha
    final groupedAppointments = <DateTime, List<Map<String, dynamic>>>{};
    for (var appointment in appointmentsData) {
      final date = appointment['date'] as DateTime;
      if (!groupedAppointments.containsKey(date)) {
        groupedAppointments[date] = [];
      }
      groupedAppointments[date]!.add(appointment);
    }

    return groupedAppointments;
  }
}
