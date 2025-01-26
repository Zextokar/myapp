import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AddClientView extends StatelessWidget {
  const AddClientView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Nuevo Cliente'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Icon(CupertinoIcons.xmark_circle_fill),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 16.0),
              CupertinoButton.filled(
                onPressed: () {
                  String name = nameController.text;
                  String address = addressController.text;
                  String phone = phoneController.text;

                  // Validación de los campos
                  if (name.isEmpty || address.isEmpty || phone.isEmpty) {
                    _showErrorDialog(context, 'Todos los campos son obligatorios');
                    return;
                  }

                  if (name.length < 3 || name.length > 100) {
                    _showErrorDialog(context, 'El nombre debe tener entre 3 y 100 caracteres');
                    return;
                  }

                  if (address.length < 5 || address.length > 200) {
                    _showErrorDialog(context, 'La dirección debe tener entre 5 y 200 caracteres');
                    return;
                  }

                  if (!RegExp(r'^\d{9,11}$').hasMatch(phone)) {
                    _showErrorDialog(context, 'El teléfono debe tener entre 9 y 11 dígitos');
                    return;
                  }

                  // Crear cliente en Firestore
                  FirebaseFirestore.instance.collection('clients').add({
                    'name': name,
                    'address': address,
                    'phone': phone,
                  });

                  // Volver a la vista de clientes
                  Navigator.of(context).pop();
                },
                child: const Text('Crear'),
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
}
