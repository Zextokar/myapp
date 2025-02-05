import 'package:flutter/cupertino.dart';

void showAddAppointmentDialog(BuildContext context, String clientId,
    Function(DateTime) onAppointmentAdded) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      final DateTime now = DateTime.now();
      DateTime selectedDate = now;

      return Container(
        height: 300,
        padding: const EdgeInsets.only(top: 16),
        color: CupertinoColors.systemBackground,
        child: Column(
          children: [
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: now,
                minimumDate: now,
                onDateTimeChanged: (DateTime newDateTime) {
                  selectedDate = newDateTime;
                },
              ),
            ),
            CupertinoButton.filled(
              onPressed: () {
                onAppointmentAdded(selectedDate);
                Navigator.of(context).pop();
              },
              child: const Text('Agendar Cita'),
            ),
          ],
        ),
      );
    },
  );
}
