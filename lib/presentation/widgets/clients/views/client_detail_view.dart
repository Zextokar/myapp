import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ClientDetailView extends StatefulWidget {
  final String clientId;
  final String clientName;
  final String clientAddress;
  final String clientPhone;

  const ClientDetailView({
    super.key,
    required this.clientId,
    required this.clientName,
    required this.clientAddress,
    required this.clientPhone,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ClientDetailViewState createState() => _ClientDetailViewState();
}

class _ClientDetailViewState extends State<ClientDetailView> {
  late Future<List<Map<String, dynamic>>> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = _loadAppointments();
  }

  Future<List<Map<String, dynamic>>> _loadAppointments() async {
    // Consulta a Firestore filtrada por client_id
    final appointmentsSnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('client_id', isEqualTo: widget.clientId)
        .get();

    // Mapear las citas al formato esperado
    final appointmentsData = appointmentsSnapshot.docs.map((doc) {
      final data = doc.data();
      final timestamp = data['date'] as Timestamp;
      final appointmentDate = DateTime(
        timestamp.toDate().year,
        timestamp.toDate().month,
        timestamp.toDate().day,
      );

      // Formatear solo la fecha (sin hora)
      String formattedDate =
          '${appointmentDate.day.toString().padLeft(2, '0')}/${appointmentDate.month.toString().padLeft(2, '0')}/${appointmentDate.year}';

      return {
        'id': doc.id,
        'date': formattedDate,
        'status': data['status'],
      };
    }).toList();

    return appointmentsData;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.clientName),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dirección y Teléfono
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.location_solid,
                              size: 20, color: CupertinoColors.activeBlue),
                          const SizedBox(width: 8),
                          Text(
                            'Dirección',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.activeBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.phone_solid,
                              size: 20, color: CupertinoColors.activeBlue),
                          const SizedBox(width: 8),
                          Text(
                            'Teléfono',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.activeBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Dirección en contenedor estilizado
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: CupertinoColors.systemGrey4, width: 1),
                      ),
                      child: Text(
                        widget.clientAddress,
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(
                                fontSize: 16,
                                color: CupertinoColors.inactiveGray),
                      ),
                    ),
                  ),
                  // Teléfono en contenedor estilizado
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: CupertinoColors.systemGrey4, width: 1),
                      ),
                      child: Text(
                        widget.clientPhone,
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(
                                fontSize: 16,
                                color: CupertinoColors.inactiveGray),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Línea divisora
              Container(
                height: 1,
                color: CupertinoColors.separator,
              ),
              const SizedBox(height: 20),
              // Información de las citas
              Text(
                'Citas del Cliente',
                style: CupertinoTheme.of(context)
                    .textTheme
                    .textStyle
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // FutureBuilder para cargar y mostrar las citas
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _appointments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CupertinoActivityIndicator();
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child:
                          Text('Error al cargar las citas: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.calendar,
                            size: 64,
                            color: CupertinoColors.systemGrey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay citas registradas para este cliente.',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(
                                  fontSize: 16,
                                  color: CupertinoColors.systemGrey,
                                  fontWeight: FontWeight.w500,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Intenta agregar una nueva cita o revisa los datos ingresados.',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(
                                  fontSize: 14,
                                  color: CupertinoColors.inactiveGray,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  final appointments = snapshot.data!;

                  return Column(
                    children: appointments.map((appointment) {
                      // Definimos el formato de la fecha
                      DateFormat dateFormat = DateFormat('dd/MM/yyyy');

                      // Parseamos la fecha del appointment en formato DateTime
                      DateTime appointmentDate =
                          dateFormat.parse(appointment['date']);
                      DateTime currentDate = DateTime.now();

                      // Determinamos si la fecha ya pasó
                      bool isPastDate = currentDate.isAfter(appointmentDate);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 1.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey6,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  CupertinoColors.systemGrey.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    CupertinoColors.systemGrey.withOpacity(0.1),
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Columna 1: Icono de calendario y Fecha
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    // Icono de calendario
                                    const Icon(
                                      CupertinoIcons.calendar,
                                      color: CupertinoColors.systemGrey,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                        width:
                                            8), // Espacio entre el icono y la fecha
                                    // Fecha
                                    Text(
                                      '${appointment['date']}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: CupertinoColors.black,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Columna 2: Icono de estado (tick o X)
                              Icon(
                                isPastDate
                                    ? CupertinoIcons.check_mark
                                    : CupertinoIcons.clear_thick_circled,
                                color: isPastDate
                                    ? CupertinoColors.systemGreen
                                    : CupertinoColors.systemRed,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 16),
              Expanded(child: Container()),
              // Botones de Eliminar y Actualizar al lado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _showUpdateClientDialog(
                          context,
                          widget.clientId,
                          widget.clientName,
                          widget.clientAddress,
                          widget.clientPhone);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5, // Fondo sutil
                        borderRadius:
                            BorderRadius.circular(8), // Bordes redondeados
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'Actualizar Cliente',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(
                              color: CupertinoColors.activeBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, widget.clientId);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemRed
                            .withOpacity(0.1), // Fondo sutil para eliminar
                        borderRadius:
                            BorderRadius.circular(8), // Bordes redondeados
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'Eliminar Cliente',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(
                              color: CupertinoColors.destructiveRed,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String clientId) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Eliminar Cliente'),
        content:
            const Text('¿Estás seguro de que quieres eliminar este cliente?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el diálogo
            },
          ),
          CupertinoDialogAction(
            child: const Text('Eliminar'),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('clients')
                  .doc(clientId)
                  .delete();
              Navigator.of(context).pop(); // Cerrar el diálogo
              Navigator.of(context).pop(); // Regresar a la pantalla de clientes
            },
          ),
        ],
      ),
    );
  }

  void _showUpdateClientDialog(BuildContext context, String clientId,
      String currentName, String currentAddress, String currentPhone) {
    TextEditingController nameController =
        TextEditingController(text: currentName);
    TextEditingController addressController =
        TextEditingController(text: currentAddress);
    TextEditingController phoneController =
        TextEditingController(text: currentPhone);

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Actualizar Cliente'),
        content: Column(
          children: [
            CupertinoTextField(
              controller: nameController,
              placeholder: 'Nombre',
            ),
            const SizedBox(height: 8.0),
            CupertinoTextField(
              controller: addressController,
              placeholder: 'Dirección',
            ),
            const SizedBox(height: 8.0),
            CupertinoTextField(
              controller: phoneController,
              placeholder: 'Teléfono',
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text('Actualizar'),
            onPressed: () {
              String name = nameController.text;
              String address = addressController.text;
              String phone = phoneController.text;

              if (name.isEmpty || address.isEmpty || phone.isEmpty) {
                _showErrorDialog(context, 'Todos los campos son obligatorios');
                return;
              }

              if (name.length < 3 || name.length > 100) {
                _showErrorDialog(
                    context, 'El nombre debe tener entre 3 y 100 caracteres');
                return;
              }

              if (address.length < 5 || address.length > 200) {
                _showErrorDialog(context,
                    'La dirección debe tener entre 5 y 200 caracteres');
                return;
              }

              if (!RegExp(r'^\d{9,11}$').hasMatch(phone)) {
                _showErrorDialog(
                    context, 'El teléfono debe tener entre 9 y 11 dígitos');
                return;
              }

              FirebaseFirestore.instance
                  .collection('clients')
                  .doc(clientId)
                  .update({
                'name': name,
                'address': address,
                'phone': phone,
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
