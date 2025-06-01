import 'package:flutter/material.dart';
import 'models.dart';
import 'theme.dart';

class DailyChallenge {
  final String title;
  final String description;
  final IconData icon;
  final String reward;
  final bool isCompleted;

  DailyChallenge({
    required this.title,
    required this.description,
    required this.icon,
    required this.reward,
    this.isCompleted = false,
  });
}

class GameSuggestion {
  final Game game;
  final String reason;
  final String estimatedTime;
  final String goal;

  GameSuggestion({
    required this.game,
    required this.reason,
    required this.estimatedTime,
    required this.goal,
  });
}

class FocusSuggestions {
  static List<DailyChallenge> getDailyChallenges() {
    return [
      DailyChallenge(
        title: "Achievement Hunter",
        description: "Unlock any achievement in Stardew Valley",
        icon: Icons.emoji_events,
        reward: "Progress Boost",
        isCompleted: false,
      ),
      DailyChallenge(
        title: "Quick Session",
        description: "Play any game for 30 minutes",
        icon: Icons.timer,
        reward: "Time Management +1",
        isCompleted: true,
      ),
      DailyChallenge(
        title: "Platform Master",
        description: "Play games on two different platforms",
        icon: Icons.device_hub,
        reward: "Versatility Badge",
        isCompleted: false,
      ),
    ];
  }

  static List<GameSuggestion> getSuggestions(List<Game> games) {
    // Find games close to completion
    var almostComplete = games.where((g) => g.percentComplete > 80).toList();
    var needsAttention = games
        .where((g) => g.lastPlayed?.isBefore(DateTime(2025, 5, 15)) ?? true)
        .toList();

    List<GameSuggestion> suggestions = [];

    // Time-based suggestions
    final now = TimeOfDay.now();
    if (now.hour < 12) {
      // Morning suggestions
      suggestions.add(
        GameSuggestion(
          game: games.firstWhere((g) => g.title == "Stardew Valley"),
          reason: "Perfect for a peaceful morning session",
          estimatedTime: "30 mins",
          goal: "Complete one in-game day",
        ),
      );
    } else if (now.hour < 17) {
      // Afternoon suggestions
      if (almostComplete.isNotEmpty) {
        suggestions.add(
          GameSuggestion(
            game: almostComplete.first,
            reason: "You're so close to completing this!",
            estimatedTime: "1-2 hours",
            goal: "Get 2 more achievements",
          ),
        );
      }
    } else {
      // Evening suggestions
      suggestions.add(
        GameSuggestion(
          game: games.firstWhere((g) => g.title == "The Witcher 3: Wild Hunt"),
          reason: "Perfect for an evening adventure",
          estimatedTime: "2+ hours",
          goal: "Complete current quest line",
        ),
      );
    }

    // Add a game needing attention
    if (needsAttention.isNotEmpty) {
      suggestions.add(
        GameSuggestion(
          game: needsAttention.first,
          reason: "Haven't played in a while",
          estimatedTime: "Any duration",
          goal: "Reconnect with the game",
        ),
      );
    }

    return suggestions;
  }

  static List<String> getSessionTips() {
    final now = TimeOfDay.now();
    List<String> tips = [
      "Remember to take breaks every hour",
      "Stay hydrated while gaming",
      "Adjust your sitting posture regularly",
    ];

    if (now.hour >= 21) {
      tips.add("Consider using blue light filter for late-night gaming");
    }

    return tips;
  }
}

class SuggestionCard extends StatelessWidget {
  final GameSuggestion suggestion;
  final VoidCallback onAccept;

  const SuggestionCard({
    super.key,
    required this.suggestion,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (suggestion.game.coverUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      suggestion.game.coverUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        suggestion.game.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        suggestion.reason,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Suggested Session",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text("⏱ ${suggestion.estimatedTime}"),
                      Text("🎯 ${suggestion.goal}"),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: onAccept,
                  child: const Text("Start Session"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final DailyChallenge challenge;
  final VoidCallback onTap;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(
          challenge.icon,
          color: challenge.isCompleted ? Colors.green : Colors.blue,
        ),
        title: Text(
          challenge.title,
          style: TextStyle(
            decoration:
                challenge.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(challenge.description),
            const SizedBox(height: 4),
            Text(
              "🏆 ${challenge.reward}",
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: challenge.isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: onTap,
              ),
      ),
    );
  }
}
