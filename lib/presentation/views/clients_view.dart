import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/presentation/widgets/clients/views/client_detail_view.dart';
import '../widgets/clients/views/add_client_view.dart';

class ClientsView extends StatelessWidget {
  const ClientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('clients')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error al cargar los datos'));
                  }

                  final clients = snapshot.data?.docs ?? [];

                  return CupertinoScrollbar(
                    child: ListView.builder(
                      itemCount: clients.length,
                      itemBuilder: (context, index) {
                        final client = clients[index];
                        final clientId = client.id;
                        final clientName = client['name'] ?? 'Sin nombre';
                        final clientAdress =
                            client['address'] ?? 'Sin dirección';
                        final clientPhone = client['phone'] ?? 'Sin teléfono';

                        return GestureDetector(
                          onTap: () {
                            // Navegar a la vista de detalles del cliente
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ClientDetailView(
                                  clientId: clientId,
                                  clientName: clientName,
                                  clientAddress: clientAdress,
                                  clientPhone: clientPhone,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: CupertinoColors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: CupertinoColors.inactiveGray
                                      .withOpacity(0.2),
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
                                        fontSize: 20,
                                        color: CupertinoColors.activeBlue,
                                      ),
                                ),
                                const SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton.filled(
                onPressed: () {
                  // Navegar a la vista de creación de cliente
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const AddClientView(),
                    ),
                  );
                },
                child: const Text(
                  'Añadir Cliente',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
