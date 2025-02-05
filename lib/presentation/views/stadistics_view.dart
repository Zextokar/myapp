import 'package:flutter/material.dart';
import 'package:myapp/presentation/widgets/stadistics/services/firestore_service.dart';
import 'package:myapp/presentation/widgets/stadistics/views/client_appointments.dart';

class FrequentClientsReport extends StatelessWidget {
  const FrequentClientsReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Aquí obtenemos los clientes frecuentes
        future: getFrequentClients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text('Error al cargar los clientes frecuentes.'));
          }

          final frequentClients = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: frequentClients.length,
                    itemBuilder: (context, index) {
                      final client = frequentClients[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(client['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Teléfono: +56 ${client['phone']}'),
                          trailing:
                              Text('Citas: ${client['appointmentsCount']}'),
                          onTap: () async {
                            final clientAppointments =
                                await getClientAppointments(client['name']);
                            if (!context.mounted) {
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ClientAppointmentsChartView(
                                  clientName: client['name'],
                                  clientAppointments: clientAppointments,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
