import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ClientAppointmentsChartView extends StatelessWidget {
  final String clientName;
  final List<Map<String, dynamic>> clientAppointments;

  const ClientAppointmentsChartView({
    super.key,
    required this.clientName,
    required this.clientAppointments,
  });

  // Agrupamos las citas por mes del año
  Map<String, int> groupAppointmentsByMonth() {
    Map<String, int> monthlyAppointments = {};

    for (var appointment in clientAppointments) {
      final date = appointment['date'] as DateTime;

      // Aseguramos que la fecha esté en la zona horaria local (sin afectar la fecha en sí)
      final localDate = date.toLocal();

      // Obtenemos el formato año-mes (yyyy-MM) para la agrupación
      final yearMonth =
          '${localDate.year}-${localDate.month.toString().padLeft(2, '0')}';

      // Contamos las citas para cada mes
      if (!monthlyAppointments.containsKey(yearMonth)) {
        monthlyAppointments[yearMonth] = 0;
      }

      monthlyAppointments[yearMonth] = monthlyAppointments[yearMonth]! + 1;
    }

    return monthlyAppointments;
  }

  @override
  Widget build(BuildContext context) {
    // Agrupamos las citas por mes
    final monthlyAppointments = groupAppointmentsByMonth();

    // Nombres de los meses en español
    final monthNames = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    // Aseguramos de que los meses estén presentes, incluso si no hay citas en un mes
    final months = [
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12'
    ];

    // Llenamos los valores de citas para cada mes (solo los meses con citas)
    final data = months.where((month) {
      final yearMonth = '${DateTime.now().year}-$month';
      return monthlyAppointments.containsKey(yearMonth) &&
          monthlyAppointments[yearMonth]! > 0;
    }).map((month) {
      final yearMonth = '${DateTime.now().year}-$month';
      return {
        'month': monthNames[
            int.parse(month) - 1], // Convertimos el número del mes a su nombre
        'appointmentsCount': monthlyAppointments[yearMonth] ?? 0,
      };
    }).toList();

    print(
        'Datos para el gráfico: $data'); // Debug: Verificamos los datos que pasamos al gráfico

    return Scaffold(
      appBar: AppBar(
        title: Text('Citas de $clientName'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            labelRotation: 45, // Rotamos las etiquetas del eje X
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: data.isEmpty
                ? 0
                : data
                    .map((e) => e['appointmentsCount'] as int)
                    .reduce((a, b) => a > b ? a : b)
                    .toDouble(),
            interval: 1, // Establecemos el intervalo en 1 para usar enteros
            labelFormat: '{value}', // Sin decimales
          ),
          title: const ChartTitle(text: 'Citas por Mes'),
          legend: const Legend(isVisible: true),
          series: <CartesianSeries>[
            ColumnSeries<Map<String, dynamic>, String>(
              dataSource: data,
              xValueMapper: (data, _) => data['month'],
              yValueMapper: (data, _) => data['appointmentsCount'],
              name: 'Citas',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
