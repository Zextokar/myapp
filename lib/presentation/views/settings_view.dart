import 'package:flutter/material.dart';
import '../widgets/config/update_checker.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido a la pantalla de Configuración',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: () {
                UpdateChecker.checkForUpdates(context);
              },
              child: const Text('Buscar actualizaciones'),
            ),
            const SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: () {},
              child: const Text('Editar configuración'),
            ),
          ],
        ),
      ),
    );
  }
}
