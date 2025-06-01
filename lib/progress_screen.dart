import 'package:flutter/material.dart';
import 'models.dart';

class ProgressScreen extends StatelessWidget {
  final List<Game> games;

  const ProgressScreen({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    final totalAchievements =
        games.fold<int>(0, (sum, game) => sum + game.totalAchievements);
    final earnedAchievements =
        games.fold<int>(0, (sum, game) => sum + game.earnedAchievements);
    final totalPlaytime =
        games.fold<double>(0, (sum, game) => sum + game.hoursPlayed);

    Map<PlatformType, int> platformCounts = {};
    for (var game in games) {
      platformCounts[game.platform] = (platformCounts[game.platform] ?? 0) + 1;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overall Stats',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatRow(Icons.games, 'Games', games.length.toString()),
            _buildStatRow(Icons.emoji_events, 'Achievements',
                '$earnedAchievements / $totalAchievements'),
            _buildStatRow(
                Icons.timer, 'Hours Played', totalPlaytime.toStringAsFixed(1)),
            const SizedBox(height: 24),
            const Text(
              'Games by Platform',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...platformCounts.entries.map((entry) {
              final percentage = (entry.value / games.length * 100).toInt();
              return _buildPlatformRow(
                entry.key,
                '${entry.value} (${percentage}%)',
              );
            }),
            const SizedBox(height: 24),
            const Text(
              'Recent Achievements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildAchievementItem(
              'Monster Slayer',
              'The Witcher 3',
              'Defeat 100 monsters',
              '2 days ago',
            ),
            _buildAchievementItem(
              'Master Farmer',
              'Stardew Valley',
              'Earn 1,000,000g',
              '5 days ago',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Text(label),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformRow(PlatformType platform, String count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(_getPlatformIcon(platform), color: Colors.blue),
          const SizedBox(width: 12),
          Text(platform.toString().split('.').last),
          const Spacer(),
          Text(count),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
      String title, String game, String description, String timeAgo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.emoji_events, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(game),
            Text(description),
          ],
        ),
        trailing: Text(
          timeAgo,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
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
