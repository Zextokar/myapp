import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, dynamic>>> _appointments = {};
  bool _isLoading = false; // Para manejar la recarga

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  /// Cargar citas desde Firestore
  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true); // Activar indicador de carga

    final appointmentsSnapshot =
        await FirebaseFirestore.instance.collection('appointments').get();
    final clientsSnapshot =
        await FirebaseFirestore.instance.collection('clients').get();

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

    setState(() {
      _appointments = groupedAppointments;
      _isLoading = false; // Desactivar indicador de carga
    });
  }

  /// Obtener eventos para un día específico
  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _appointments[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAppointments, // Función para recargar datos
        child: Column(
          children: [
            // Calendario interactivo
            TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2050),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: (day) => _getEventsForDay(day),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Indicador de carga al recargar eventos
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            // Lista de eventos del día seleccionado
            Expanded(
              child: _selectedDay == null
                  ? const Center(
                      child: Text('Selecciona un día para ver las citas'))
                  : _buildEventsList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Construir la lista de eventos
  Widget _buildEventsList() {
    final events = _getEventsForDay(_selectedDay!);

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
