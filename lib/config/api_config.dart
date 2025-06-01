class ApiConfig {
  static const String steamApiKey = 'DCEC91C4088DACF1051D27F8C5A76D65';
  static const String defaultSteamId = '76561198057698641';
  static const String hltbApiEndpoint = 'https://howlongtobeat.com/api/games';
  static const String steamApiBase = 'https://api.steampowered.com';

  // Cache duration
  static const Duration cacheDuration = Duration(hours: 24);

  // SharedPreferences keys
  static const String steamIdKey = 'steam_id';
  static const String gameTimeCachePrefix = 'game_time_';
}
