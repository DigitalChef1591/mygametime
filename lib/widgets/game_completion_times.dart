import 'package:flutter/material.dart';
import '../services/service_provider.dart';

class GameCompletionTimes extends StatefulWidget {
  final String gameName;

  const GameCompletionTimes({
    super.key,
    required this.gameName,
  });

  @override
  State<GameCompletionTimes> createState() => _GameCompletionTimesState();
}

class _GameCompletionTimesState extends State<GameCompletionTimes> {
  bool _isLoading = true;
  Map<String, dynamic>? _completionTimes;
  final ServiceProvider _serviceProvider = ServiceProvider();

  @override
  void initState() {
    super.initState();
    _loadCompletionTimes();
  }

  Future<void> _loadCompletionTimes() async {
    try {
      final times =
          await _serviceProvider.getGameCompletionTimes(widget.gameName);
      setState(() {
        _completionTimes = times;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_completionTimes == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Completion Times",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _CompletionTimeColumn(
                  icon: Icons.speed,
                  label: "Main Story",
                  hours: _completionTimes!['mainStoryTime']?.toDouble() ?? 0,
                ),
                _CompletionTimeColumn(
                  icon: Icons.extension,
                  label: "Main + Extras",
                  hours: _completionTimes!['mainExtraTime']?.toDouble() ?? 0,
                ),
                _CompletionTimeColumn(
                  icon: Icons.stars,
                  label: "Completionist",
                  hours:
                      _completionTimes!['completionistTime']?.toDouble() ?? 0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletionTimeColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final double hours;

  const _CompletionTimeColumn({
    required this.icon,
    required this.label,
    required this.hours,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 8),
        Text(
          "${hours.toStringAsFixed(1)}h",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
