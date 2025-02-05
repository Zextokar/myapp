import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Text(
              '¡Hola, Bienvenido!',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Explora las opciones a continuación para configurar tu experiencia.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            // Sección de accesos rápidos
            Text(
              'Accesos rápidos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _QuickAccessButton(
                  icon: Icons.person,
                  label: 'Clientes',
                  onTap: () {
                    // Navegar a otra pantalla
                  },
                ),
                _QuickAccessButton(
                  icon: Icons.settings,
                  label: 'Configuración',
                  onTap: () {
                    // Navegar a otra pantalla
                  },
                ),
                _QuickAccessButton(
                  icon: Icons.analytics,
                  label: 'Reportes',
                  onTap: () {
                    // Navegar a otra pantalla
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Lista de opciones
            Text(
              'Opciones generales',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar Inicio'),
              subtitle: const Text('Personaliza la pantalla principal.'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Acción para editar inicio
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Ayuda'),
              subtitle: const Text('Obtén soporte y guías.'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Acción para abrir ayuda
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Acerca de'),
              subtitle: const Text('Información de la aplicación.'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Acción para abrir "Acerca de"
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Botón personalizado para accesos rápidos
class _QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAccessButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor:
                // ignore: deprecated_member_use
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Icon(icon,
                size: 30, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
