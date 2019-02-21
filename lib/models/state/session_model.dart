import 'package:yes_music/models/spotify/player_state_model.dart';
import 'package:yes_music/models/state/song_model.dart';
import 'package:yes_music/models/state/user_model.dart';

/// A session of users.
class SessionModel {
  /// The current player state.
  final PlayerStateModel playerState;

  /// The current queue of upcoming songs.
  final List<SongModel> queue;

  /// The history of songs that have been played.
  final List<SongModel> history;

  /// The list of current users.
  final List<UserModel> users;

  SessionModel(this.playerState, this.queue, this.history, this.users);

  SessionModel.fromMap(Map map)
      : playerState = PlayerStateModel.fromMap(map["playerState"]),
        queue = SongModel.fromMapList(map["queue"]),
        history = SongModel.fromMapList(map["history"]),
        users = UserModel.fromMapList(map["users"]);

  Map<String, dynamic> toMap() {
    return {
      "playerState": playerState.toMap(),
      "queue": SongModel.toMapList(queue),
      "history": SongModel.toMapList(history),
      "users": UserModel.toMapList(users),
    };
  }
}
