import 'dart:async';
import 'dart:convert';

import 'package:distributed_computing_project/classes/message.dart';
import 'package:distributed_computing_project/classes/session.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../classes/player.dart';

class ApiClient {
  static const String baseUrl = 'localhost:3000';

  static Future<int> addPlayer(Player player) async {
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

  static Future<List<Player>> getPlayers() async {
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

  static Future<int> addSession(Session session) async {
    final Uri url = Uri.http(baseUrl, '/addSession');
    final Map<String, String> headers = {
      'Content-Type': 'application/json'
    };

    String parsedSessionName = session.sessionName.split("'").join("''");
    String chatId = const Uuid().v4();

    final body = jsonEncode({
      'sessionID': session.id,
      'start': session.start.toString(),
      'sessionName': parsedSessionName,
      'private': session.private,
      'password': session.password,
      'numberOfPlayers': session.numberOfPlayers,
      'numberOfLaps': session.numberOfLaps,
      'chatID': chatId
    });

    final http.Response response = await http.post(url, headers: headers, body: body);
    return response.statusCode;
  }
  
  static Future<List<Session>> getSessions(bool active) async {
    final Uri url = Uri.http(baseUrl, '/sessions');
    
    try {
      final http.Response response = await http.get(url, headers: {'active': active.toString()});
      if (response.statusCode == 200) {
        List<Session> sessions = [];
        List<dynamic> responseData = json.decode(response.body);
        for (dynamic row in responseData) {
          Session session = Session(
            id: row['sessionID'],
            start: DateTime.parse(row['start']),
            sessionName: row['sessionName'],
            private: row['private'],
            numberOfPlayers: row['numberOfPlayers'],
            numberOfLaps: row['numberOfLaps'],
            state: row['state']
          );
          if (!active) {
            session.playersId = (row['playersID'] as List).map((item) => item as String).toList();
            session.end = row['end'] != null ?  DateTime.parse(row['end']) : null;
            session.winnerId = row['winnerID'];
          }
          if (session.private) {
            session.password = row['password'];
          }
          sessions.add(session);
        }
        return sessions;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return[];
  }
  
  static Future<String> getChatId(String sessionId) async {
    final Uri url = Uri.http(baseUrl, '/chat');
    try {
      final http.Response response = await http.get(url, headers: {'sessionID': sessionId});
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (error) {
      debugPrint(error.toString());
      return '';
    }
    return '';
  }

  static Future<List<Message>> getMessagesBySession(String sessionId) async {
    final Uri url = Uri.http(baseUrl, '/messages');
    
    try {
      final http.Response response = await http.get(url, headers: {'sessionID': sessionId});
      if (response.statusCode == 200) {
        List<Message> messages = [];
        List<dynamic> responseData = json.decode(response.body);
        for (dynamic row in responseData) {
          Message message = Message(
            id: row['messageID'],
            chatId: row['chatID'],
            from: row['from'],
            private: row['private'],
            content: row['content'],
          );
          message.to = message.private ? row['to'] : null;
          message.time = DateTime.parse(row['time']);

          messages.add(message);
        }
        return messages;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return[];
  }

  static Future<int> addMessage(Message message) async {
    final Uri url = Uri.http(baseUrl, '/addmessage');
    final Map<String, String> headers = {
      'Content-Type': 'application/json'
    };

    final body = jsonEncode({
      'messageID': message.id,
      'chatID': message.chatId,
      'from': message.from,
      'to': message.to,
      'private': message.private,
      'content': message.content,
      'time': message.time.toString()
    });

    final http.Response response = await http.post(url, headers: headers, body: body);
    return response.statusCode;
  }
}