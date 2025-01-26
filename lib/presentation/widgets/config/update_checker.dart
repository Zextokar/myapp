import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker {
  static const String currentVersion = "1.0.0"; // Versión actual de la app
  static const String apiUrl =
      "https://api.github.com/repos/Zextokar/myapp/releases/latest";

  static Future<void> checkForUpdates(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final latestVersion = data['tag_name'];
        final downloadUrl = data['assets'][0]['browser_download_url'];

        if (_isNewVersionAvailable(currentVersion, latestVersion)) {
          _showUpdateDialog(context, downloadUrl);
        } else {
          _showNoUpdateDialog(context);
        }
      } else {
        throw Exception("Error al obtener la información de la actualización.");
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  static bool _isNewVersionAvailable(
      String currentVersion, String latestVersion) {
    return latestVersion.compareTo("v$currentVersion") > 0;
  }

  static void _showUpdateDialog(BuildContext context, String downloadUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nueva actualización disponible"),
        content: const Text(
            "Hay una nueva versión disponible. ¿Deseas descargarla?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              _launchURL(downloadUrl);
              Navigator.pop(context);
            },
            child: const Text("Descargar"),
          ),
        ],
      ),
    );
  }

  static void _showNoUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text("Sin actualizaciones"),
        content: Text("Ya tienes la última versión instalada."),
      ),
    );
  }

  static void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text("Ocurrió un error al buscar actualizaciones: $error"),
      ),
    );
  }

  static void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se puede abrir el enlace: $url';
    }
  }
}
