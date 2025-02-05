import 'package:flutter/cupertino.dart';

void showDeleteConfirmationDialog(
  BuildContext context,
  Function() onDelete,
) {
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
            onDelete();
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
