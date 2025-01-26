import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/pets/pet_card.dart';
import '../widgets/pets/dialogs/add_pet_dialog.dart';

class PetsView extends StatelessWidget {
  const PetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Mascotas'),
        trailing: GestureDetector(
          onTap: () => _showAddPetDialog(context),
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
                  return PetCard(pet: pet);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddPetDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => const AddPetDialog(),
    );
  }
}
