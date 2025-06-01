import 'package:flutter/material.dart';
import 'models.dart';
import 'package:intl/intl.dart';

class AchievementAnalytics extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementAnalytics({super.key, required this.achievements});

  List<Achievement> get _sortedByRarity {
    final sorted = List<Achievement>.from(achievements);
    sorted.sort(
      (a, b) => (a.percentPlayers ?? 0).compareTo(b.percentPlayers ?? 0),
    );
    return sorted;
  }

  List<Achievement> get _unlockedAchievements {
    return achievements.where((a) => a.isUnlocked).toList();
  }

  double get _completionRate {
    if (achievements.isEmpty) return 0;
    return _unlockedAchievements.length / achievements.length * 100;
  }

  int get _rareAchievementsCount {
    return achievements.where((a) => (a.percentPlayers ?? 100) < 10).length;
  }

  int get _ultraRareAchievementsCount {
    return achievements.where((a) => (a.percentPlayers ?? 100) < 5).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievement Analytics'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCompletionCard(),
            _buildRarityBreakdown(),
            _buildRarityDistribution(),
            if (_unlockedAchievements.isNotEmpty) _buildUnlockTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Completion Progress',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _completionRate / 100,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              '${_unlockedAchievements.length}/${achievements.length} Achievements (${_completionRate.toStringAsFixed(1)}%)',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRarityBreakdown() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rarity Breakdown',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildRarityRow(
              'Ultra Rare (< 5%)',
              _ultraRareAchievementsCount,
              Colors.purple,
            ),
            const SizedBox(height: 8),
            _buildRarityRow(
              'Rare (5-10%)',
              _rareAchievementsCount - _ultraRareAchievementsCount,
              Colors.amber,
            ),
            const SizedBox(height: 8),
            _buildRarityRow(
              'Common (> 10%)',
              achievements.length - _rareAchievementsCount,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRarityRow(String label, int count, Color color) {
    return Row(
      children: [
        Icon(Icons.circle, size: 12, color: color),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
        Text(
          count.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRarityDistribution() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rarity Distribution',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sortedByRarity.length,
              itemBuilder: (context, index) {
                final achievement = _sortedByRarity[index];
                return ListTile(
                  title: Text(achievement.name),
                  subtitle: Text(
                    achievement.isUnlocked ? 'Unlocked' : 'Locked',
                    style: TextStyle(
                      color:
                          achievement.isUnlocked ? Colors.green : Colors.grey,
                    ),
                  ),
                  trailing: Text(
                    '${achievement.percentPlayers?.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: (achievement.percentPlayers ?? 0) < 10
                          ? Colors.amber
                          : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockTimeline() {
    final unlocked = _unlockedAchievements
        .where((a) => a.unlockedTime != null)
        .toList()
      ..sort((a, b) => a.unlockedTime!.compareTo(b.unlockedTime!));

    if (unlocked.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Unlock Timeline',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: unlocked.length,
              itemBuilder: (context, index) {
                final achievement = unlocked[index];
                return ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(achievement.name),
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(achievement.unlockedTime!),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
