import 'package:flutter/foundation.dart';

enum PlatformType {
  steam,
  epic,
  psn,
  xbox,
  nintendo,
  playstation,
  other,
}

enum GameStatus { notStarted, inProgress, completed, abandoned, onHold }

enum Priority { high, medium, low, none }

class GameSession {
  final DateTime startTime;
  final DateTime endTime;
  final String notes;

  GameSession({
    required this.startTime,
    required this.endTime,
    this.notes = '',
  });

  double get duration => endTime.difference(startTime).inMinutes / 60.0;

  Map<String, dynamic> toJson() => {
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'notes': notes,
      };

  factory GameSession.fromJson(Map<String, dynamic> json) {
    return GameSession(
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      notes: json['notes'] as String? ?? '',
    );
  }
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final bool isUnlocked;
  final DateTime? unlockedTime;
  final String? iconUrl;
  final double? percentPlayers;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    this.isUnlocked = false,
    this.unlockedTime,
    this.iconUrl,
    this.percentPlayers,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'isUnlocked': isUnlocked,
        'unlockedTime': unlockedTime?.toIso8601String(),
        'iconUrl': iconUrl,
        'percentPlayers': percentPlayers,
      };

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedTime: json['unlockedTime'] != null
          ? DateTime.parse(json['unlockedTime'] as String)
          : null,
      iconUrl: json['iconUrl'] as String?,
      percentPlayers: json['percentPlayers'] as double?,
    );
  }
}

@immutable
class Game {
  final String id;
  final String title;
  final PlatformType platform;
  final String coverUrl;
  final double hoursPlayed;
  final DateTime lastPlayed;
  final int totalAchievements;
  final int earnedAchievements;
  final double percentComplete;
  final List<Achievement> achievements;
  final List<GameSession> sessions;
  final String notes;
  final GameStatus status;
  final DateTime? completionDate;
  final double? completionTime;
  final Priority priority;

  const Game({
    required this.id,
    required this.title,
    required this.platform,
    required this.coverUrl,
    this.hoursPlayed = 0.0,
    required this.lastPlayed,
    this.totalAchievements = 0,
    this.earnedAchievements = 0,
    this.percentComplete = 0.0,
    this.achievements = const [],
    this.sessions = const [],
    this.notes = '',
    this.status = GameStatus.notStarted,
    this.completionDate,
    this.completionTime,
    this.priority = Priority.none,
  });

  Game copyWith({
    String? id,
    String? title,
    PlatformType? platform,
    String? coverUrl,
    double? hoursPlayed,
    DateTime? lastPlayed,
    int? totalAchievements,
    int? earnedAchievements,
    double? percentComplete,
    List<Achievement>? achievements,
    List<GameSession>? sessions,
    String? notes,
    GameStatus? status,
    DateTime? completionDate,
    double? completionTime,
    Priority? priority,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      platform: platform ?? this.platform,
      coverUrl: coverUrl ?? this.coverUrl,
      hoursPlayed: hoursPlayed ?? this.hoursPlayed,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      totalAchievements: totalAchievements ?? this.totalAchievements,
      earnedAchievements: earnedAchievements ?? this.earnedAchievements,
      percentComplete: percentComplete ?? this.percentComplete,
      achievements: achievements ?? this.achievements,
      sessions: sessions ?? this.sessions,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      completionDate: completionDate ?? this.completionDate,
      completionTime: completionTime ?? this.completionTime,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'platform': platform.toString(),
        'coverUrl': coverUrl,
        'hoursPlayed': hoursPlayed,
        'lastPlayed': lastPlayed.toIso8601String(),
        'totalAchievements': totalAchievements,
        'earnedAchievements': earnedAchievements,
        'percentComplete': percentComplete,
        'achievements': achievements.map((a) => a.toJson()).toList(),
        'sessions': sessions.map((s) => s.toJson()).toList(),
        'notes': notes,
        'status': status.toString(),
        'completionDate': completionDate?.toIso8601String(),
        'completionTime': completionTime,
        'priority': priority.toString(),
      };

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      title: json['title'] as String,
      platform: PlatformType.values.firstWhere(
        (e) => e.toString() == json['platform'],
      ),
      coverUrl: json['coverUrl'] as String,
      hoursPlayed: json['hoursPlayed'] as double? ?? 0.0,
      lastPlayed: DateTime.parse(json['lastPlayed'] as String),
      totalAchievements: json['totalAchievements'] as int? ?? 0,
      earnedAchievements: json['earnedAchievements'] as int? ?? 0,
      percentComplete: json['percentComplete'] as double? ?? 0.0,
      achievements: (json['achievements'] as List?)
              ?.map((a) => Achievement.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      sessions: (json['sessions'] as List?)
              ?.map((s) => GameSession.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      notes: json['notes'] as String? ?? '',
      status: GameStatus.values
          .firstWhere((e) => e.toString() == (json['status'] as String)),
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'] as String)
          : null,
      completionTime: json['completionTime'] as double?,
      priority: json['priority'] != null
          ? Priority.values.firstWhere((e) => e.toString() == json['priority'])
          : Priority.none,
    );
  }
}

class SteamProfile {
  final String steamId;
  final List<Game> games;
  final DateTime lastUpdated;

  SteamProfile({
    required this.steamId,
    required this.games,
    required this.lastUpdated,
  });

  SteamProfile copyWith({
    String? steamId,
    List<Game>? games,
    DateTime? lastUpdated,
  }) =>
      SteamProfile(
        steamId: steamId ?? this.steamId,
        games: games ?? this.games,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  Map<String, dynamic> toJson() => {
        'steamId': steamId,
        'games': games.map((g) => g.toJson()).toList(),
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  factory SteamProfile.fromJson(Map<String, dynamic> json) => SteamProfile(
        steamId: json['steamId'] as String,
        games: (json['games'] as List)
            .map((g) => Game.fromJson(g as Map<String, dynamic>))
            .toList(),
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );
}
