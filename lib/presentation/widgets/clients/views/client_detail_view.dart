import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ClientDetailView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(clientName),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información básica del cliente
              Text(
                'Nombre',
                style: CupertinoTheme.of(context)
                    .textTheme
                    .textStyle
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                clientName,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontSize: 16, color: CupertinoColors.inactiveGray),
              ),
              const SizedBox(height: 16),

              Text(
                'Dirección',
                style: CupertinoTheme.of(context)
                    .textTheme
                    .textStyle
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                clientAddress,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontSize: 16, color: CupertinoColors.inactiveGray),
              ),
              const SizedBox(height: 16),

              Text(
                'Teléfono',
                style: CupertinoTheme.of(context)
                    .textTheme
                    .textStyle
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                clientPhone,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontSize: 16, color: CupertinoColors.inactiveGray),
              ),

              const SizedBox(height: 20),

              // Línea divisora
              Container(
                height: 1,
                color: CupertinoColors.separator,
              ),

              const SizedBox(height: 20),

              // Información de las citas (por ahora solo un texto de ejemplo)
              Text(
                'Citas del Cliente',
                style: CupertinoTheme.of(context)
                    .textTheme
                    .textStyle
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Aquí irán las citas, por ahora es un texto de ejemplo.
              Text(
                'Aquí aparecerán las citas del cliente.',
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontSize: 16, color: CupertinoColors.inactiveGray),
              ),

              const Spacer(),

              // Botones de Eliminar y Actualizar al lado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _showUpdateClientDialog(context, clientId, clientName,
                          clientAddress, clientPhone);
                    },
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
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, clientId);
                    },
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
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text('Eliminar'),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('clients')
                  .doc(clientId)
                  .delete();
              Navigator.of(context).pop();
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
