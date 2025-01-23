import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:myapp/presentation/views/home_view.dart';
import 'package:myapp/presentation/views/calendar_view.dart';
import 'package:myapp/presentation/views/clients_view.dart';
import 'package:myapp/presentation/views/pets_view.dart';
import 'package:myapp/presentation/views/settings_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Asegúrate de que el índice inicial sea 2 para HomeView
  int selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const CalendarView(),
      const ClientsView(),
      const HomeView(), // Home es el tercer índice (2)
      const PetsView(),
      const SettingsView(),
    ];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          _getAppBarTitle(selectedIndex),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: screens,
        ),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar),
              activeIcon: Icon(CupertinoIcons.calendar,
                  color: CupertinoColors.activeBlue),
              label: 'Calendario',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.group),
              activeIcon:
                  Icon(CupertinoIcons.group, color: CupertinoColors.activeBlue),
              label: 'Clientes',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              activeIcon:
                  Icon(CupertinoIcons.home, color: CupertinoColors.activeBlue),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.paw),
              activeIcon:
                  Icon(CupertinoIcons.paw, color: CupertinoColors.activeBlue),
              label: 'Mascotas',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              activeIcon: Icon(CupertinoIcons.settings,
                  color: CupertinoColors.activeBlue),
              label: 'Configuración',
            ),
          ],
        ),
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Calendario';
      case 1:
        return 'Clientes';
      case 2:
        return 'Inicio'; // Título para la HomeView
      case 3:
        return 'Mascotas';
      case 4:
        return 'Configuración';
      default:
        return '';
    }
  }
}
