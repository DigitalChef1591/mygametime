import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameTime',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const GameTimeHome(),
    );
  }
}

class GameTimeHome extends StatefulWidget {
  const GameTimeHome({super.key});

  @override
  State<GameTimeHome> createState() => _GameTimeHomeState();
}

class _GameTimeHomeState extends State<GameTimeHome> {
  int _selectedIndex = 0;
  final List<Game> _games = [
    Game(
      id: '1',
      title: 'The Witcher 3: Wild Hunt',
      platform: PlatformType.steam,
      coverUrl: 'https://cdn.cloudflare.steamstatic.com/steam/apps/292030/header.jpg',
      hoursPlayed: 45.5,
      lastPlayed: DateTime(2025, 5, 1),
      totalAchievements: 78,
      earnedAchievements: 25,
      status: GameStatus.inProgress,
      percentComplete: 32.0,
      priority: Priority.high,
      notes: '',
      achievements: [
        Achievement(
          id: 'monster_slayer',
          name: 'Monster Slayer',
          description: 'Defeat 100 monsters',
          isUnlocked: true,
          iconUrl: '',
          percentPlayers: 45.2,
        ),
      ],
      sessions: [],
    ),
    Game(
      id: '2',
      title: 'Halo Infinite',
      platform: PlatformType.xbox,
      coverUrl: 'https://store-images.s-microsoft.com/image/apps.21536.13727851868390641.c9cc5f66-aff8-406c-af6b-440838730be0.68796bde-cbf5-4eaa-a299-011417041da6',
      hoursPlayed: 20.0,
      lastPlayed: DateTime(2025, 5, 15),
      totalAchievements: 119,
      earnedAchievements: 50,
      status: GameStatus.inProgress,
      percentComplete: 55.0,
      priority: Priority.medium,
      notes: '',
      achievements: [],
      sessions: [],
    ),
    Game(
      id: '3',
      title: 'God of War Ragnarök',
      platform: PlatformType.playstation,
      coverUrl: 'https://i.imgur.com/5lqQzH3.jpg',
      hoursPlayed: 10.0,
      lastPlayed: DateTime(2025, 4, 28),
      totalAchievements: 36,
      earnedAchievements: 12,
      status: GameStatus.inProgress,
      percentComplete: 20.0,
      priority: Priority.high,
      notes: '',
      achievements: [],
      sessions: [],
    ),
    Game(
      id: '4',
      title: 'Stardew Valley',
      platform: PlatformType.steam,
      coverUrl: 'https://cdn.cloudflare.steamstatic.com/steam/apps/413150/header.jpg',
      hoursPlayed: 150.0,
      lastPlayed: DateTime(2025, 5, 30),
      totalAchievements: 40,
      earnedAchievements: 38,
      status: GameStatus.completed,
      percentComplete: 96.0,
      priority: Priority.none,
      notes: '',
      achievements: [
        Achievement(
          id: 'master_farmer',
          name: 'Master Farmer',
          description: 'Earn 1,000,000g',
          isUnlocked: true,
          iconUrl: '',
          percentPlayers: 12.8,
        ),
      ],
      sessions: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getScreenTitle(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_selectedIndex == 0)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // TODO: Implement add game
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildLibraryView(),
                _buildProgressView(),
                _buildBacklogView(),
                _buildFocusView(),
                _buildSettingsView(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Backlog',
          ),
          NavigationDestination(
            icon: Icon(Icons.flash_on),
            label: 'Focus',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  String _getScreenTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Library';
      case 1:
        return 'Progress';
      case 2:
        return 'Backlog';
      case 3:
        return 'Focus';
      case 4:
        return 'Settings';
      default:
        return 'GameTime';
    }
  }

  Widget _buildLibraryView() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: _games.length,
      itemBuilder: (context, index) {
        final game = _games[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _buildGameDetailsView(game),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      game.coverUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.videogame_asset),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          game.platform.toString().split('.').last,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Achievements: ${game.earnedAchievements}/${game.totalAchievements}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Played: ${game.hoursPlayed}h (${game.percentComplete.toInt()}%)',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Last played:',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd').format(game.lastPlayed),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressView() {
    final totalPlaytime = _games.fold<double>(
      0,
      (sum, game) => sum + game.hoursPlayed,
    );

    final totalAchievements = _games.fold<int>(
      0,
      (sum, game) => sum + game.totalAchievements,
    );

    final earnedAchievements = _games.fold<int>(
      0,
      (sum, game) => sum + game.earnedAchievements,
    );

    // Calculate platform stats
    Map<PlatformType, int> platformCounts = {};
    for (var game in _games) {
      platformCounts[game.platform] = (platformCounts[game.platform] ?? 0) + 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overall Stats',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            'Games',
            _games.length.toString(),
            Icons.games,
          ),
          _buildStatCard(
            'Achievements',
            '$earnedAchievements / $totalAchievements',
            Icons.emoji_events,
          ),
          _buildStatCard(
            'Hours Played',
            totalPlaytime.toStringAsFixed(1),
            Icons.timer,
          ),
          const SizedBox(height: 24),
          const Text(
            'Games by Platform',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...platformCounts.entries.map((e) {
            final percentage = (e.value / _games.length * 100).toInt();
            return _buildPlatformRow(
              e.key,
              '${e.value} (${percentage}%)',
            );
          }),
          const SizedBox(height: 24),
          const Text(
            'Recent Achievements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildAchievementRow(
            'Monster Slayer',
            'The Witcher 3',
            'Defeat 100 monsters',
            '2 days ago',
          ),
          _buildAchievementRow(
            'Master Farmer',
            'Stardew Valley',
            'Earn 1,000,000g',
            '5 days ago',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 16),
            Text(label),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
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

  Widget _buildAchievementRow(String title, String game, String description, String timeAgo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
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

  Widget _buildBacklogView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Priority'),
                    DropdownButton<String>(
                      value: 'All',
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All')),
                        DropdownMenuItem(value: 'High', child: Text('High')),
                        DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                        DropdownMenuItem(value: 'Low', child: Text('Low')),
                      ],
                      onChanged: (String? value) {
                        // TODO: Implement filter
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
                      value: 'All',
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All')),
                        DropdownMenuItem(
                            value: 'Not Started', child: Text('Not Starte