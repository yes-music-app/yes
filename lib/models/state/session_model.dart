import 'package:yes_music/helpers/list_utils.dart';
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

  /// The host of this session.
  final UserModel host;

  /// The list of current users.
  final List<UserModel> users;

  SessionModel(
    this.playerState,
    this.queue,
    this.history,
    this.host,
    this.users,
  );

  SessionModel.fromMap(Map map)
      : playerState = map["playerState"] == null
            ? null
            : PlayerStateModel.fromMap(map["playerState"]),
        queue = SongModel.fromMapList(map["queue"]),
        history = SongModel.fromMapList(map["history"]),
        host = UserModel.fromMap(map["host"]),
        users = UserModel.fromMapList(map["users"]);

  Map<String, dynamic> toMap() {
    return {
      "playerState": playerState?.toMap(),
      "queue": SongModel.toMapList(queue),
      "history": SongModel.toMapList(history),
      "host": host?.toMap(),
      "users": UserModel.toMapList(users),
    };
  }

  @override
  bool operator ==(other) =>
      other is SessionModel &&
      other.playerState == playerState &&
      listsEqual(other.queue, queue) &&
      listsEqual(other.history, history) &&
      other.host == host &&
      listsEqual(other.users, users);

  @override
  int get hashCode =>
      playerState.hashCode ^
      queue.hashCode ^
      history.hashCode ^
      host.hashCode ^
      users.hashCode;
}
