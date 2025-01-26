import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ClientSelector extends StatefulWidget {
  final Function(String) onClientSelected;

  const ClientSelector({required this.onClientSelected, super.key});

  @override
  State<ClientSelector> createState() => _ClientSelectorState();
}

class _ClientSelectorState extends State<ClientSelector> {
  String? selectedClientName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('clients').snapshots(),
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
                    child: Text("Cliente: ${client['name']}"),
                    onPressed: () {
                      setState(() {
                        selectedClientName = client['name'];
                      });
                      widget.onClientSelected(client.id);
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
    );
  }
}