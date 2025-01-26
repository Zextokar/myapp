import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../client_selector.dart';

class AddPetDialog extends StatefulWidget {
  const AddPetDialog({super.key});

  @override
  State<AddPetDialog> createState() => _AddPetDialogState();
}

class _AddPetDialogState extends State<AddPetDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  String? selectedClientId;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Nueva Mascota'),
      content: Column(
        children: [
          CupertinoTextField(
            controller: nameController,
            placeholder: 'Nombre de la Mascota',
          ),
          const SizedBox(height: 8.0),
          CupertinoTextField(
            controller: breedController,
            placeholder: 'Raza de la Mascota',
          ),
          const SizedBox(height: 8.0),
          ClientSelector(
            onClientSelected: (clientId) {
              setState(() {
                selectedClientId = clientId;
              });
            },
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
          child: const Text('Crear'),
          onPressed: () {
            final name = nameController.text;
            final breed = breedController.text;

            if (name.isEmpty || breed.isEmpty || selectedClientId == null) {
              _showErrorDialog('Todos los campos son obligatorios');
              return;
            }

            FirebaseFirestore.instance.collection('pets').add({
              'name': name,
              'breed': breed,
              'client_id': selectedClientId,
            });
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _showErrorDialog(String message) {
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
