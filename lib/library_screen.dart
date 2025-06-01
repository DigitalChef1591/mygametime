import 'package:flutter/material.dart';
import 'models.dart';

class LibraryScreen extends StatelessWidget {
  final List<Game> games;

  const LibraryScreen({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Library',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return _buildGameListItem(game);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGameListItem(Game game) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            game.coverUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(game.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(game.platform.toString().split('.').last),
            Text(
                'Achievements: ${game.earnedAchievements}/${game.totalAchievements}'),
            Text(
                'Played: ${game.hoursPlayed}h (${game.percentComplete.toInt()}%)'),
          ],
        ),
        trailing: Text(
          'Last played:\n${game.lastPlayed.year}-${game.lastPlayed.month.toString().padLeft(2, '0')}-${game.lastPlayed.day.toString().padLeft(2, '0')}',
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
