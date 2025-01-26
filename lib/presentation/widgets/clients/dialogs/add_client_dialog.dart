import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../shared_validations.dart';

void showAddClientDialog(BuildContext context) {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Nuevo Cliente'),
      content: Column(
        children: [
          CupertinoTextField(
            controller: nameController,
            placeholder: 'Nombre Completo',
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        CupertinoDialogAction(
          child: const Text('Crear'),
          onPressed: () {
            final name = nameController.text;
            final address = addressController.text;
            final phone = phoneController.text;

            final errorMessage = validateClientData(name, address, phone);
            if (errorMessage != null) {
              showErrorDialog(context, errorMessage);
              return;
            }

            FirebaseFirestore.instance.collection('clients').add({
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

void showErrorDialog(BuildContext context, String message) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
