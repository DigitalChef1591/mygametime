import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models.dart';

class GameDetailsScreen extends StatelessWidget {
  final Game game;
  final List<Achievement> _achievements = [
    Achievement(
      id: '1',
      name: 'First Steps',
      description: 'Complete the tutorial',
      isUnlocked: true,
      iconUrl: '',
      percentPlayers: 92.5,
    ),
    Achievement(
      id: '2',
      name: 'Speed Runner',
      description: 'Complete a level in under 2 minutes',
      isUnlocked: false,
      iconUrl: '',
      percentPlayers: 8.3,
    ),
  ];

  GameDetailsScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(game.title),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Sessions'),
              Tab(text: 'Achievements'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildSessionsTab(),
            _buildAchievementsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              game.coverUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.videogame_asset, size: 64),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(_getPlatformIcon(game.platform)),
                    const SizedBox(width: 8),
                    Text(
                      game.platform.toString().split('.').last,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: game.percentComplete / 100,
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 8),
                Text('${game.percentComplete.toStringAsFixed(1)}% Complete'),
                const SizedBox(height: 16),
                _buildStatRow('Achievements',
                    '${game.earnedAchievements}/${game.totalAchievements}'),
                _buildStatRow('Playtime', '${game.hoursPlayed}h'),
                _buildStatRow('Last played',
                    DateFormat('yyyy-MM-dd').format(game.lastPlayed)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildSessionsTab() {
    return ListView.builder(
      itemCount: game.sessions.length,
      itemBuilder: (context, index) {
        final session = game.sessions[index];
        return ListTile(
          title: Text(DateFormat('yyyy-MM-dd').format(session.startTime)),
          subtitle: Text('Duration: ${session.duration.toStringAsFixed(1)}h'),
        );
      },
    );
  }

  Widget _buildAchievementsTab() {
    return Column(
      children: [
        LinearProgressIndicator(
          value: game.earnedAchievements / game.totalAchievements,
          backgroundColor: Colors.grey[200],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${game.earnedAchievements}/${game.totalAchievements} Achievements',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _achievements.length,
            itemBuilder: (context, index) {
              final achievement = _achievements[index];
              return ListTile(
                leading: Icon(
                  achievement.isUnlocked ? Icons.lock_open : Icons.lock,
                  color: achievement.isUnlocked ? Colors.green : Colors.grey,
                ),
                title: Text(achievement.name),
                subtitle: Text(achievement.description),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getPlatformIcon(PlatformType platform) {
    switch (platform) {
      case PlatformType.steam:
        return Icons.computer;
      case PlatformType.epic:
        return Icons.games;
      case PlatformType.psn:
      case PlatformType.playstation:
        return Icons.sports_esports;
      case PlatformType.xbox:
        return Icons.gamepad;
      case PlatformType.nintendo:
        return Icons.videogame_asset;
      case PlatformType.other:
        return Icons.devices_other;
    }
  }
}
