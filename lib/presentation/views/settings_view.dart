import 'package:flutter/material.dart';
import '../widgets/config/update_checker.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Bienvenida
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.blue),
              title: const Text('Bienvenido'),
              subtitle: const Text('Ajusta tus preferencias'),
              onTap: () {},
            ),
            const Divider(),

            // Actualización
            ListTile(
              leading: const Icon(Icons.system_update_alt, color: Colors.green),
              title: const Text('Buscar actualizaciones'),
              onTap: () {
                UpdateChecker.checkForUpdates(context);
              },
            ),
            const Divider(),

            // Configuración de perfil
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.orange),
              title: const Text('Editar configuración'),
              onTap: () {},
            ),
            const Divider(),

            // Funcionalidades futuras
            ListTile(
              leading: const Icon(Icons.security, color: Colors.red),
              title: const Text('Seguridad y Privacidad'),
              subtitle: const Text('Configura tu seguridad'),
              onTap: () {},
            ),
            const Divider(),

            // Función de temas
            ListTile(
              leading: const Icon(Icons.palette, color: Colors.purple),
              title: const Text('Tema de la aplicación'),
              subtitle: const Text('Cambia el modo de la app'),
              onTap: () {},
            ),
            const Divider(),

            // Notificaciones
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.blue),
              title: const Text('Notificaciones'),
              subtitle: const Text('Configura tus notificaciones'),
              onTap: () {},
            ),
            const Divider(),

            // Ayuda
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.green),
              title: const Text('Ayuda'),
              onTap: () {},
            ),
            const Divider(),

            // Cerrar sesión
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Cerrar sesión'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
