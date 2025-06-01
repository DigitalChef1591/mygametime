import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class HowLongToBeatService {
  Future<Map<String, dynamic>?> getGameCompletionTimes(String gameName) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.hltbApiEndpoint}/search'),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'My GameTime App/1.0.0',
        },
        body: json.encode({
          'searchType': 'games',
          'searchTerms': [gameName],
          'searchPage': 1,
          'size': 1,
          'searchOptions': {
            'games': {
              'userId': 0,
              'platform': '',
              'sortCategory': 'popular',
              'rangeCategory': 'main',
              'rangeTime': {
                'min': 0,
                'max': 0,
              },
              'gameplay': {
                'perspective': '',
                'flow': '',
                'genre': '',
              },
              'modifier': '',
            },
            'users': {
              'sortCategory': 'postcount',
            },
            'filter': '',
            'sort': 0,
            'randomizer': 0,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          final game = data['data'][0];
          return {
            'mainStoryTime': game['comp_main'] ?? 0,
            'mainExtraTime': game['comp_plus'] ?? 0,
            'completionistTime': game['comp_100'] ?? 0,
            'cached_at': DateTime.now().millisecondsSinceEpoch,
          };
        }
      }
    } catch (e) {
      print('Error fetching HLTB data: $e');
    }
    return null;
  }
}
