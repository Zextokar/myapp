import 'package:flutter/cupertino.dart';
import 'package:myapp/presentation/widgets/clients/dialogs/add_appointment_dialog.dart';
import 'package:myapp/presentation/widgets/clients/dialogs/update_client_dialog.dart';
import 'package:myapp/presentation/widgets/clients/dialogs/delete_confirmation_dialog.dart';
import 'package:myapp/presentation/widgets/clients/services/client_service.dart';

class ClientDetailView extends StatefulWidget {
  final String clientId;
  final String clientName;
  final String clientAddress;
  final String clientPhone;

  const ClientDetailView({
    super.key,
    required this.clientId,
    required this.clientName,
    required this.clientAddress,
    required this.clientPhone,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ClientDetailViewState createState() => _ClientDetailViewState();
}

class _ClientDetailViewState extends State<ClientDetailView> {
  final ClientService _clientService = ClientService();

  @override
  void initState() {
    super.initState();
  }

  void _refreshAppointments() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.clientName),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... (resto del código de la UI)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showAddAppointmentDialog(
                          context,
                          widget.clientId,
                          (date) async {
                            await _clientService.addAppointment(
                                widget.clientId, date);
                            _refreshAppointments();
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey5,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  CupertinoColors.systemGrey.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.calendar_badge_plus,
                          size: 28,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showUpdateClientDialog(
                          context,
                          widget.clientId,
                          widget.clientName,
                          widget.clientAddress,
                          widget.clientPhone,
                          (name, address, phone) async {
                            await _clientService.updateClient(
                              widget.clientId,
                              name,
                              address,
                              phone,
                            );
                            setState(() {});
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey5,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  CupertinoColors.systemGrey.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.pencil_circle,
                          size: 28,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showDeleteConfirmationDialog(
                          context,
                          () async {
                            await _clientService.deleteClient(widget.clientId);
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  CupertinoColors.systemGrey.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.trash_circle,
                          size: 28,
                          color: CupertinoColors.destructiveRed,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
