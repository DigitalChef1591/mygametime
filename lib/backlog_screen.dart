import 'package:flutter/material.dart';
import 'models.dart';
import 'game_details_screen.dart';

class BacklogScreen extends StatefulWidget {
  final List<Game> games;

  const BacklogScreen({super.key, required this.games});

  @override
  State<BacklogScreen> createState() => _BacklogScreenState();
}

class _BacklogScreenState extends State<BacklogScreen> {
  String _priorityFilter = 'All';
  String _statusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Priority'),
                    DropdownButton<String>(
                      value: _priorityFilter,
                      isExpanded: true,
                      items: ['All', ...Priority.values.map((p) => p.name)]
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _priorityFilter = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Status'),
                    DropdownButton<String>(
                      value: _statusFilter,
                      isExpanded: true,
                      items: ['All', ...GameStatus.values.map((s) => s.name)]
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _statusFilter = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              _buildBacklogItem(
                'Elden Ring',
                'steam',
                Priority.high,
              ),
              _buildBacklogItem(
                'Final Fantasy XVI',
                'playstation',
                Priority.medium,
              ),
              _buildBacklogItem(
                'Starfield',
                'xbox',
                Priority.high,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBacklogItem(String title, String platform, Priority priority) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const FlutterLogo(size: 56.0),
        title: Text(title),
        subtitle: Text(platform),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPriorityColor(priority).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                priority.name,
                style: TextStyle(
                  color: _getPriorityColor(priority),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () {
          // Navigate to game details
        },
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.blue;
      case Priority.none:
        return Colors.grey;
    }
  }
}
