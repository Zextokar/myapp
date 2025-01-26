import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../clients/dialogs/update_client_dialog.dart';

class ClientCard extends StatelessWidget {
  final String clientId;
  final String name;
  final String address;
  final String phone;

  const ClientCard({
    super.key,
    required this.clientId,
    required this.name,
    required this.address,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
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
          Text(
            name,
            style: CupertinoTheme.of(context)
                .textTheme
                .navLargeTitleTextStyle
                .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Dirección: $address',
            style: CupertinoTheme.of(context)
                .textTheme
                .textStyle
                .copyWith(fontSize: 16, color: CupertinoColors.systemGrey),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Teléfono: $phone',
            style: CupertinoTheme.of(context)
                .textTheme
                .textStyle
                .copyWith(fontSize: 16, color: CupertinoColors.systemGrey),
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('clients')
                      .doc(clientId)
                      .delete();
                },
                child: const Icon(CupertinoIcons.delete,
                    color: CupertinoColors.destructiveRed),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  showUpdateClientDialog(
                    context,
                    clientId: clientId,
                    currentName: name,
                    currentAddress: address,
                    currentPhone: phone,
                  );
                },
                child: const Icon(CupertinoIcons.pencil,
                    color: CupertinoColors.activeBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
