import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

void showEditPetDialog(BuildContext context, String petId, String currentName,
    String currentBreed, String currentClientId) {
  final nameController = TextEditingController(text: currentName);
  final breedController = TextEditingController(text: currentBreed);
  String? selectedClientId = currentClientId;
  String? selectedClientName;

  showCupertinoDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return CupertinoAlertDialog(
          title: const Text('Editar Mascota'),
          content: Column(
            children: [
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: nameController,
                placeholder: 'Nombre de la Mascota',
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: breedController,
                placeholder: 'Raza de la Mascota',
              ),
              const SizedBox(height: 12),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('clients')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CupertinoActivityIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text('Error al cargar clientes');
                  }
                  final clients = snapshot.data?.docs ?? [];
                  return CupertinoButton(
                    child: Text(
                      selectedClientName ?? 'Selecciona un Cliente',
                      style: const TextStyle(
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          title: const Text('Selecciona un Cliente'),
                          actions: clients.map((client) {
                            return CupertinoActionSheetAction(
                              child: Text(client['name']),
                              onPressed: () {
                                setState(() {
                                  selectedClientId = client.id;
                                  selectedClientName = client['name'];
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          }).toList(),
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    },
                  );
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
              child: const Text('Actualizar'),
              onPressed: () async {
                final name = nameController.text.trim();
                final breed = breedController.text.trim();

                if (name.isEmpty || breed.isEmpty || selectedClientId == null) {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Error'),
                      content: const Text('Todos los campos son obligatorios'),
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
                  return;
                }

                final navigator =
                    Navigator.of(context); // Captura el NavigatorState
                await FirebaseFirestore.instance
                    .collection('pets')
                    .doc(petId)
                    .update({
                  'name': name,
                  'breed': breed,
                  'client_id': selectedClientId,
                });

                if (navigator.mounted) {
                  // Verifica si el widget sigue montado
                  navigator.pop();
                }
              },
            ),
          ],
        );
      },
    ),
  );
}
