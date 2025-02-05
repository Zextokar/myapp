import 'package:flutter/cupertino.dart';

void showUpdateClientDialog(
  BuildContext context,
  String clientId,
  String currentName,
  String currentAddress,
  String currentPhone,
  Function(String, String, String) onUpdate,
) {
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
            onUpdate(
              nameController.text,
              addressController.text,
              phoneController.text,
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
