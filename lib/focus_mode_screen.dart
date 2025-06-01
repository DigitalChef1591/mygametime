import 'package:flutter/material.dart';
import 'models.dart';

class FocusScreen extends StatelessWidget {
  final List<Game> games;

  const FocusScreen({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    final inProgressGames =
        games.where((g) => g.status == GameStatus.inProgress).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Focus Mode',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Select a game to focus on',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: inProgressGames.length,
            itemBuilder: (context, index) {
              final game = inProgressGames[index];
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
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.videogame_asset),
                        );
                      },
                    ),
                  ),
                  title: Text(game.title),
                  subtitle: Text(
                      '${game.percentComplete.toStringAsFixed(1)}% complete'),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () {
                    // TODO: Implement focus mode
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
