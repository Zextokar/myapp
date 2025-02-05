import 'package:flutter/material.dart';

class EventsList extends StatelessWidget {
  final List<Map<String, dynamic>> events;

  const EventsList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(
        child: Text(
          'No hay eventos para este día',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final time = event['time'] ?? 'Sin hora';
        final status = event['status'] ?? 'Desconocido';
        final clientName = event['client_name'];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hora: $time',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cliente: $clientName',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Estado: ${status == 'booked' ? 'Reservado' : 'Disponible'}',
                style: TextStyle(
                  fontSize: 14,
                  color: status == 'booked' ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
