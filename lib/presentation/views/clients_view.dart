import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ClientsView extends StatelessWidget {
  const ClientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Clientes'),
        trailing: GestureDetector(
          onTap: () {
            _showAddClientDialog(context);
          },
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('clients').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar los datos'));
            }

            final clients = snapshot.data?.docs ?? [];

            return CupertinoScrollbar(
              child: ListView.builder(
                itemCount: clients.length,
                itemBuilder: (context, index) {
                  final client = clients[index];
                  final clientId = client.id;
                  final clientName = client['name'] ?? 'Sin nombre';
                  final clientAdress = client['address'] ?? 'Sin correo';
                  final clientPhone = client['phone'] ?? 'Sin teléfono';

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
                          clientName,
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
                          'Dirección: $clientAdress',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .copyWith(
                                fontSize: 16,
                                color: CupertinoColors.systemGrey,
                              ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Teléfono: $clientPhone',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .copyWith(
                                fontSize: 16,
                                color: CupertinoColors.systemGrey,
                              ),
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    context, clientId);
                              },
                              child: const Icon(CupertinoIcons.delete,
                                  color: CupertinoColors.destructiveRed),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _showUpdateClientDialog(context, clientId,
                                    clientName, clientAdress, clientPhone);
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

  void _showAddClientDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

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
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text('Crear'),
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

  // Mostrar mensaje de error
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
