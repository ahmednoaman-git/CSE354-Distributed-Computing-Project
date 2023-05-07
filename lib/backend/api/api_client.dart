import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../classes/player.dart';

class ApiClient {
  final String baseUrl;

  ApiClient(this.baseUrl);

  Future<List<dynamic>?> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<int> addPlayer(Player player) async {
    final Uri url = Uri.http(baseUrl, '/addplayer');
    final Map<String, String> headers = {
      'Content-Type': 'application/json'
    };

    final body = jsonEncode({
      'playerID': player.playerID,
      'username': player.userName,
      'password': player.password,
      'imageUrl': player.imageUrl
    });

    final http.Response response = await http.post(url, headers: headers, body: body);
    return response.statusCode;
  }

  Future<List<Player>> getPlayers() async {
    final Uri url = Uri.http(baseUrl, '/players');
    try {
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        List<Player> playerData = [];
        List<dynamic> responseData = json.decode(response.body);
        for (dynamic row in responseData) {
          playerData.add(Player(
            playerID: row['playerID'] ?? '',
            userName: row['username'] ?? '',
            password: row['password'] ?? '',
            connected: row['connected'] == 'true',
            lastSeen: row['lastSeen'],
            imageUrl: row['imageUrl'] ?? ''
          ));
        }
        return playerData;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return[];
  }
}