import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ServiceProvider {
  static final ServiceProvider _instance = ServiceProvider._internal();

  factory ServiceProvider() {
    return _instance;
  }

  ServiceProvider._internal();

  SharedPreferences? _prefs;
  String? _steamId;
  Map<String, String> _webStorage = {};
  final DateTime _currentTime = DateTime(2025, 6, 1, 20, 59, 11);
  final String _currentUser = 'DigitalChef1591';

  Future<void> initialize() async {
    try {
      if (!kIsWeb) {
        _prefs = await SharedPreferences.getInstance();
        _steamId = _prefs?.getString(ApiConfig.steamIdKey);
      }
    } catch (e) {
      print('Storage initialization error: $e');
      // Fallback to in-memory storage
      _webStorage = {};
    }
  }

  Future<String?> getSteamId() async {
    if (!kIsWeb && _prefs != null) {
      return _prefs?.getString(ApiConfig.steamIdKey);
    }
    return _webStorage[ApiConfig.steamIdKey];
  }

  Future<void> setSteamId(String id) async {
    _steamId = id;
    if (!kIsWeb && _prefs != null) {
      await _prefs?.setString(ApiConfig.steamIdKey, id);
    } else {
      _webStorage[ApiConfig.steamIdKey] = id;
    }
  }

  Future<void> clearSteamId() async {
    _steamId = null;
    if (!kIsWeb && _prefs != null) {
      await _prefs?.remove(ApiConfig.steamIdKey);
    } else {
      _webStorage.remove(ApiConfig.steamIdKey);
    }
  }

  Future<Map<String, dynamic>?> getGameCompletionTimes(String gameName) async {
    final cacheKey =
        '${ApiConfig.gameTimeCachePrefix}${gameName.toLowerCase().replaceAll(' ', '_')}';
    String? cachedData;

    if (!kIsWeb && _prefs != null) {
      cachedData = _prefs?.getString(cacheKey);
    } else {
      cachedData = _webStorage[cacheKey];
    }

    if (cachedData != null) {
      try {
        final data = json.decode(cachedData);
        final cachedAt = DateTime.fromMillisecondsSinceEpoch(data['cached_at']);
        if (DateTime.now().difference(cachedAt) < ApiConfig.cacheDuration) {
          return data;
        }
      } catch (e) {
        print('Cache parsing error: $e');
      }
    }

    try {
      // Mock implementation - in a real app, this would call the HLTB API
      await Future.delayed(const Duration(milliseconds: 500));
      final completionTimes = {
        'mainStoryTime': 20.5,
        'mainExtraTime': 35.0,
        'completionistTime': 50.0,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      };

      final encodedData = json.encode(completionTimes);
      if (!kIsWeb && _prefs != null) {
        await _prefs?.setString(cacheKey, encodedData);
      } else {
        _webStorage[cacheKey] = encodedData;
      }

      return completionTimes;
    } catch (e) {
      print('Error fetching completion times: $e');
      return null;
    }
  }

  Future<void> _saveToStorage(String key, String value) async {
    if (!kIsWeb && _prefs != null) {
      await _prefs?.setString(key, value);
    } else {
      _webStorage[key] = value;
    }
  }

  String? _getFromStorage(String key) {
    if (!kIsWeb && _prefs != null) {
      return _prefs?.getString(key);
    }
    return _webStorage[key];
  }

  DateTime getCurrentTime() => _currentTime;

  String getCurrentUser() => _currentUser;
}
