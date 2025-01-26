import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../shared_validations.dart';

void showUpdateClientDialog(
  BuildContext context, {
  required String clientId,
  required String currentName,
  required String currentAddress,
  required String currentPhone,
}) {
  final nameController = TextEditingController(text: currentName);
  final addressController = TextEditingController(text: currentAddress);
  final phoneController = TextEditingController(text: currentPhone);

  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Editar Cliente'),
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        CupertinoDialogAction(
          child: const Text('Guardar'),
          onPressed: () {
            final name = nameController.text;
            final address = addressController.text;
            final phone = phoneController.text;

            final errorMessage = validateClientData(name, address, phone);
            if (errorMessage != null) {
              showErrorDialog(context, errorMessage);
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
