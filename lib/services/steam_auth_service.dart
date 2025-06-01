import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import './steam_service.dart';
import '../models.dart';

class SteamAuthService extends ChangeNotifier {
  final SteamService _steamService;
  bool _isAuthenticated = false;
  String? _steamId;
  SteamProfile? _profile;

  SteamAuthService() : _steamService = SteamService(ApiConfig.steamApiKey) {
    _loadSavedProfile();
  }

  bool get isAuthenticated => _isAuthenticated;
  SteamProfile? get profile => _profile;
  String? get steamId => _steamId;

  Future<void> _loadSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _steamId = prefs.getString(ApiConfig.steamIdKey);
    final profileJson = prefs.getString('steam_profile');

    if (_steamId != null && profileJson != null) {
      try {
        _profile = SteamProfile.fromJson(json.decode(profileJson));
        _isAuthenticated = true;
        notifyListeners();
        refreshLibrary();
      } catch (e) {
        print('Error loading saved profile: $e');
        await logout();
      }
    }
  }

  Future<void> login() async {
    // For demo, we'll use the default Steam ID
    _steamId = ApiConfig.defaultSteamId;
    await _saveAndLoadProfile();
  }

  Future<void> _saveAndLoadProfile() async {
    if (_steamId == null) return;

    try {
      final games = await _steamService.getUserGames(_steamId!);

      _profile = SteamProfile(
        steamId: _steamId!,
        games: games,
        lastUpdated: DateTime(2025, 6, 1, 21, 28, 25),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(ApiConfig.steamIdKey, _steamId!);
      await prefs.setString('steam_profile', json.encode(_profile!.toJson()));

      _isAuthenticated = true;
      notifyListeners();

      _updateAchievementStats();
    } catch (e) {
      print('Error saving and loading profile: $e');
      await logout();
    }
  }

  Future<void> refreshLibrary() async {
    if (_steamId == null) return;

    try {
      final games = await _steamService.getUserGames(_steamId!);
      _profile = _profile?.copyWith(
        games: games,
        lastUpdated: DateTime(2025, 6, 1, 21, 28, 25),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('steam_profile', json.encode(_profile!.toJson()));

      notifyListeners();

      _updateAchievementStats();
    } catch (e) {
      print('Error refreshing library: $e');
    }
  }

  Future<void> _updateAchievementStats() async {
    if (_profile == null) return;

    List<Game> updatedGames = [];
    for (final game in _profile!.games) {
      try {
        final updatedGame =
            await _steamService.updateGameAchievementStats(game);
        updatedGames.add(updatedGame);
      } catch (e) {
        print('Error updating achievements for game ${game.title}: $e');
        updatedGames.add(game);
      }
    }

    _profile = _profile?.copyWith(
      games: updatedGames,
      lastUpdated: DateTime(2025, 6, 1, 21, 28, 25),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('steam_profile', json.encode(_profile!.toJson()));

    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _steamId = null;
    _profile = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConfig.steamIdKey);
    await prefs.remove('steam_profile');

    notifyListeners();
  }
}
