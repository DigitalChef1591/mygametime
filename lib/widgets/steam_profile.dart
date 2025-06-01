import 'package:flutter/material.dart';
import '../services/service_provider.dart';

class SteamProfile extends StatefulWidget {
  const SteamProfile({super.key});

  @override
  State<SteamProfile> createState() => _SteamProfileState();
}

class _SteamProfileState extends State<SteamProfile> {
  final TextEditingController _steamIdController = TextEditingController();
  bool _isLoading = false;
  String? _steamId;
  final ServiceProvider _serviceProvider = ServiceProvider();

  @override
  void initState() {
    super.initState();
    _loadSteamId();
  }

  Future<void> _loadSteamId() async {
    setState(() {
      _isLoading = true;
    });

    _steamId = await _serviceProvider.getSteamId();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _connectSteam() async {
    if (_steamIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your Steam ID')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _serviceProvider.setSteamId(_steamIdController.text);
      _steamId = _steamIdController.text;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error connecting to Steam: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_steamId == null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Connect your Steam account to sync your games',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _steamIdController,
              decoration: const InputDecoration(
                labelText: 'Steam ID',
                hintText: 'Enter your Steam ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _connectSteam,
              child: const Text('Connect Steam Account'),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Text('Connected as: $_steamId'),
    );
  }
}
