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
                            decoration: BoxDecoration(
                              color: CupertinoColors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: CupertinoColors
                                    .systemGrey4, // Color del borde
                                width: 1.0,
                              ),
                            ),
                            child: CupertinoFormRow(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons
                                            .person, // Icono del cliente
                                        color: CupertinoColors.activeBlue,
                                      ),
                                      const SizedBox(
                                          width:
                                              10), // Espacio entre el icono y el texto
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
                                    ],
                                  ),
                                  const Icon(
                                    CupertinoIcons
                                        .right_chevron, // Flecha de navegación
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centra verticalmente
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        bottom: 16), // Agrega el margen inferior
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centra horizontalmente el Row
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets
                              .zero, // Elimina el padding predeterminado de CupertinoButton
                          onPressed: () {
                            // Navegar a la vista de creación de cliente
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const AddClientView(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey5, // Fondo sutil
                              borderRadius: BorderRadius.circular(
                                  8), // Bordes redondeados
                              boxShadow: [
                                BoxShadow(
                                  color: CupertinoColors.systemGrey
                                      .withOpacity(0.3),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'Agregar Cliente',
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(
                                    color: CupertinoColors.activeBlue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
