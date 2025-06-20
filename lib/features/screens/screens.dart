import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Screens extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const Screens({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        destinations:
            destinations
                .map(
                  (destination) => NavigationDestination(
                    icon: Icon(destination.icon),
                    label: destination.label,
                    selectedIcon: Icon(destination.icon, color: Colors.white),
                  ),
                )
                .toList(),

        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index)=>navigationShell.goBranch(index),
        indicatorColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class Destination {
  const Destination({required this.label, required this.icon});
  final String label;
  final IconData icon;
}

const destinations = [
  Destination(label: 'Chats', icon: Icons.chat),
  Destination(label: 'Calls', icon: Icons.call_sharp),
];
