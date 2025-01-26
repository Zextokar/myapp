import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dialogs/update_pet_dialog.dart';

class PetCard extends StatelessWidget {
  final QueryDocumentSnapshot pet;

  const PetCard({required this.pet, super.key});

  @override
  Widget build(BuildContext context) {
    final petId = pet.id; // ID único de la mascota
    final petName = pet['name'] ?? 'Sin nombre';
    final petBreed = pet['breed'] ?? 'Sin raza';
    final clientId = pet['client_id'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Row(
                children: [
                  // Botón para Editar
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showEditPetDialog(
                        context,
                        petId,
                        petName,
                        petBreed,
                        clientId,
                      );
                    },
                    child: const Icon(
                      CupertinoIcons.pencil,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                  // Botón para Eliminar
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, petId);
                    },
                    child: const Icon(
                      CupertinoIcons.delete,
                      color: CupertinoColors.destructiveRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            'Raza: $petBreed',
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 16,
                  color: CupertinoColors.systemGrey,
                ),
          ),
          const SizedBox(height: 8.0),
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('clients')
                .doc(clientId)
                .get(),
            builder: (context, clientSnapshot) {
              if (clientSnapshot.connectionState == ConnectionState.waiting) {
                return const CupertinoActivityIndicator();
              }

              if (clientSnapshot.hasError) {
                return const Text('Error al cargar cliente');
              }

              final clientData = clientSnapshot.data;
              final clientName = clientData?['name'] ?? 'Cliente desconocido';

              return Text(
                'Cliente: $clientName',
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontSize: 16,
                      color: CupertinoColors.systemGrey,
                    ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Método para mostrar el diálogo de confirmación de eliminación
  void _showDeleteConfirmationDialog(BuildContext context, String petId) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Eliminar Mascota'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar esta mascota?',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text(
              'Eliminar',
              style: TextStyle(color: CupertinoColors.destructiveRed),
            ),
            onPressed: () async {
              final navigator =
                  Navigator.of(context); // Captura el NavigatorState
              await FirebaseFirestore.instance
                  .collection('pets')
                  .doc(petId)
                  .delete();

              if (navigator.mounted) {
                // Verifica si el contexto aún está montado
                navigator.pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
