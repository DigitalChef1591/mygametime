import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Account'),
          subtitle: const Text('Manage your account settings'),
          onTap: () {
            // TODO: Implement account settings
          },
        ),
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text('Sync'),
          subtitle: const Text('Manage sync settings and frequency'),
          onTap: () {
            // TODO: Implement sync settings
          },
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          subtitle: const Text('Configure notification preferences'),
          onTap: () {
            // TODO: Implement notification settings
          },
        ),
        ListTile(
          leading: const Icon(Icons.color_lens),
          title: const Text('Appearance'),
          subtitle: const Text('Customize app appearance'),
          onTap: () {
            // TODO: Implement appearance settings
          },
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About'),
          subtitle: const Text('App version and information'),
          onTap: () {
            // TODO: Implement about screen
          },
        ),
      ],
    );
  }
}
