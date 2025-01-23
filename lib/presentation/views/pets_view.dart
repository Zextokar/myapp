import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PetsView extends StatelessWidget {
  const PetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Mascotas'),
        trailing: GestureDetector(
          onTap: () {
            _showAddPetDialog(context);
          },
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('pets').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar los datos'));
            }

            final pets = snapshot.data?.docs ?? [];

            return CupertinoScrollbar(
              child: ListView.builder(
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  final pet = pets[index];
                  final petName = pet['name'] ?? 'Sin nombre';
                  final petBreed = pet['breed'] ?? 'Sin raza';
                  final clientId = pet['client_id'];

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.inactiveGray.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          petName,
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navLargeTitleTextStyle
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Raza: $petBreed',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .copyWith(
                                fontSize: 16,
                                color: CupertinoColors.systemGrey,
                              ),
                        ),
                        const SizedBox(height: 8.0),
                        // Agregamos la consulta para obtener el nombre del cliente
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('clients')
                              .doc(clientId)
                              .get(),
                          builder: (context, clientSnapshot) {
                            if (clientSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CupertinoActivityIndicator();
                            }

                            if (clientSnapshot.hasError) {
                              return const Text('Error al cargar cliente');
                            }

                            final clientData = clientSnapshot.data;
                            final clientName =
                                clientData?['name'] ?? 'Cliente desconocido';

                            return Text(
                              'Cliente: $clientName',
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(
                                    fontSize: 16,
                                    color: CupertinoColors.systemGrey,
                                  ),
                            );
                          },
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _showDeletePetConfirmationDialog(
                                    context, pet.id);
                              },
                              child: const Icon(CupertinoIcons.delete,
                                  color: CupertinoColors.destructiveRed),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _showUpdatePetDialog(context, pet.id, petName,
                                    petBreed, clientId);
                              },
                              child: const Icon(CupertinoIcons.pencil,
                                  color: CupertinoColors.activeBlue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddPetDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController breedController = TextEditingController();
    String? selectedClientId;

    // Obtención de clientes para mostrar en el action sheet
    final clientStream =
        FirebaseFirestore.instance.collection('clients').snapshots();

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
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
            StreamBuilder<QuerySnapshot>(
              stream: clientStream,
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
                    selectedClientId == null
                        ? 'Selecciona un Cliente'
                        : 'Cliente: ${clients.firstWhere((client) => client.id == selectedClientId)['name']}',
                    style: const TextStyle(color: CupertinoColors.activeBlue),
                  ),
                  onPressed: () {
                    _showClientSelectionSheet(context, clients,
                        (selectedClient) {
                      selectedClientId = selectedClient.id;
                    });
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
            child: const Text('Crear'),
            onPressed: () {
              String name = nameController.text;
              String breed = breedController.text;

              // Validación de los campos
              if (name.isEmpty || breed.isEmpty || selectedClientId == null) {
                _showErrorDialog(context, 'Todos los campos son obligatorios');
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
      ),
    );
  }

  void _showClientSelectionSheet(
      BuildContext context,
      List<QueryDocumentSnapshot> clients,
      Function(QueryDocumentSnapshot) onClientSelected) {
    String? tempSelectedClientId;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return CupertinoActionSheet(
            title: const Text('Selecciona un Cliente'),
            actions: clients.map((client) {
              return CupertinoActionSheetAction(
                child: Text(client['name']),
                onPressed: () {
                  // Actualizamos el cliente seleccionado temporalmente
                  tempSelectedClientId = client.id;
                  setState(() {}); // Actualiza el estado dentro del modal

                  // Notificamos al callback principal
                  onClientSelected(client);

                  // Cerramos el modal
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
          );
        },
      ),
    );
  }

  void _showDeletePetConfirmationDialog(BuildContext context, String petId) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Eliminar Mascota'),
        content:
            const Text('¿Estás seguro de que quieres eliminar esta mascota?'),
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
              FirebaseFirestore.instance.collection('pets').doc(petId).delete();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showUpdatePetDialog(BuildContext context, String petId,
      String currentName, String currentBreed, String currentClientId) {
    TextEditingController nameController =
        TextEditingController(text: currentName);
    TextEditingController breedController =
        TextEditingController(text: currentBreed);
    String? selectedClientId = currentClientId;

    // Obtención de clientes para mostrar en el action sheet
    final clientStream =
        FirebaseFirestore.instance.collection('clients').snapshots();

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Actualizar Mascota'),
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
            StreamBuilder<QuerySnapshot>(
              stream: clientStream,
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
                    selectedClientId == null
                        ? 'Selecciona un Cliente'
                        : 'Cliente: ${clients.firstWhere((client) => client.id == selectedClientId)['name']}',
                    style: const TextStyle(color: CupertinoColors.activeBlue),
                  ),
                  onPressed: () {
                    _showClientSelectionSheet(context, clients,
                        (selectedClient) {
                      selectedClientId = selectedClient.id;
                    });
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
            onPressed: () {
              String name = nameController.text;
              String breed = breedController.text;

              if (name.isEmpty || breed.isEmpty || selectedClientId == null) {
                _showErrorDialog(context, 'Todos los campos son obligatorios');
                return;
              }

              FirebaseFirestore.instance.collection('pets').doc(petId).update({
                'name': name,
                'breed': breed,
                'client_id': selectedClientId,
              });
              Navigator.of(context).pop();
            },
          ),
        ],
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
