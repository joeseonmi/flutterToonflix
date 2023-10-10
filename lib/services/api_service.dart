import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toonflix2/models/webtoon_detail_model.dart';
import 'package:toonflix2/models/webtoon_episode_model.dart';
import 'package:toonflix2/models/webtoon_model.dart';

class ApiService {
  static String baseUrl = 'http://webtoon-crawler.nomadcoders.workers.dev';
  static const String today = 'today';

  static Future<List<WebtoonModel>> getTodaysWebtoons() async {
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    List<WebtoonModel> webtoonInstances = [];
    //future가 기다렸다가 response type으로 준다
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        final toon = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(toon);
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);
    //future가 기다렸다가 response type으로 준다
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getEpisodeById(String id) async {
    final url = Uri.parse('$baseUrl/$id/episodes');
    final response = await http.get(url);
    List<WebtoonEpisodeModel> episodesInstances = [];
    //future가 기다렸다가 response type으로 준다
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        final toonEpisode = WebtoonEpisodeModel.fromJson(episode);
        episodesInstances.add(toonEpisode);
      }
      return episodesInstances;
    }
    throw Error();
  }
}
