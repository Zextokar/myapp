import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/clients/dialogs/add_client_dialog.dart';
import '../widgets/clients/client_card.dart';

class ClientsView extends StatelessWidget {
  const ClientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Clientes'),
        trailing: GestureDetector(
          onTap: () => showAddClientDialog(context),
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
                  final clientData = client.data() as Map<String, dynamic>;

                  return ClientCard(
                    clientId: clientId,
                    name: clientData['name'] ?? 'Sin nombre',
                    address: clientData['address'] ?? 'Sin dirección',
                    phone: clientData['phone'] ?? 'Sin teléfono',
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
