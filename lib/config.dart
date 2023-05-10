import 'package:distributed_computing_project/classes/player.dart';
import 'package:distributed_computing_project/classes/session.dart';

class Config {
  static Player currentPlayer = Player(playerID: '', userName: '', password: '', imageUrl: '');
  static Session currentSession = Session(id: '', start: DateTime.now(), sessionName: '', private: false, numberOfPlayers: 0, numberOfLaps: 0, state: '');
  static String currentChatId = '';
}