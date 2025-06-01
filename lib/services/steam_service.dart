import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models.dart';

class SteamService {
  final String apiKey;
  static const String steamApiBase = 'https://api.steampowered.com';

  SteamService(this.apiKey);

  Future<List<Game>> getUserGames(String steamId) async {
    final response = await http.get(
      Uri.parse(
        '$steamApiBase/IPlayerService/GetOwnedGames/v1/?key=${ApiConfig.steamApiKey}&steamid=$steamId&include_appinfo=true&include_played_free_games=true',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['response'] != null && data['response']['games'] != null) {
        return (data['response']['games'] as List)
            .map((game) => Game(
                  id: game['appid'].toString(),
                  title: game['name'],
                  platform: PlatformType.steam,
                  coverUrl:
                      'https://steamcdn-a.akamaihd.net/steam/apps/${game['appid']}/header.jpg',
                  hoursPlayed: (game['playtime_forever'] ?? 0) / 60,
                  lastPlayed: game['rtime_last_played'] != null
                      ? DateTime.fromMillisecondsSinceEpoch(
                          game['rtime_last_played'] * 1000)
                      : DateTime(2025, 6, 1, 21, 28, 25),
                  totalAchievements: 0,
                  earnedAchievements: 0,
                  percentComplete: 0,
                  achievements: [],
                  sessions: [],
                  notes: '',
                  status: GameStatus.notStarted,
                ))
            .toList();
      }
    }
    return [];
  }

  Future<Game> updateGameAchievementStats(Game game) async {
    try {
      final steamId = await getSteamId();
      if (steamId == null) return game;

      final response = await http.get(
        Uri.parse(
          '$steamApiBase/ISteamUserStats/GetPlayerAchievements/v1/?appid=${game.id}&key=${ApiConfig.steamApiKey}&steamid=$steamId',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['playerstats'] != null &&
            data['playerstats']['achievements'] != null) {
          final achievements = data['playerstats']['achievements'] as List;
          final totalAchievements = achievements.length;
          final earnedAchievements =
              achievements.where((a) => a['achieved'] == 1).length;
          final percentComplete =
              (earnedAchievements / totalAchievements * 100).round().toDouble();

          return Game(
            id: game.id,
            title: game.title,
            platform: game.platform,
            coverUrl: game.coverUrl,
            hoursPlayed: game.hoursPlayed,
            lastPlayed: game.lastPlayed,
            totalAchievements: totalAchievements,
            earnedAchievements: earnedAchievements,
            percentComplete: percentComplete,
            achievements: game.achievements,
            sessions: game.sessions,
            notes: game.notes,
            status: game.status,
          );
        }
      }
    } catch (e) {
      print('Error updating achievement stats: $e');
    }
    return game;
  }

  Future<String?> getSteamId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ApiConfig.steamIdKey) ?? ApiConfig.defaultSteamId;
  }
}
