import 'package:yes_music/helpers/list_utils.dart';
import 'package:yes_music/models/spotify/player_state_model.dart';
import 'package:yes_music/models/state/song_model.dart';
import 'package:yes_music/models/state/user_model.dart';

const String SESSION_PATH = "sessions";
const String SID_PATH = "sid";
const String STATE_PATH = "playerState";
const String QUEUE_PATH = "queue";
const String HISTORY_PATH = "history";
const String HOST_PATH = "host";
const String USERS_PATH = "users";

/// A session of users.
class SessionModel {
  /// This session's ID.
  final String sid;

  /// The current player state.
  final PlayerStateModel playerState;

  /// The current queue of upcoming songs.
  final List<SongModel> queue;

  /// The history of songs that have been played.
  final List<SongModel> history;

  /// The host of this session.
  final String host;

  /// The list of current users.
  final List<UserModel> users;

  SessionModel.empty(String sid, UserModel newHost)
      : sid = sid,
        playerState = null,
        queue = [],
        history = [],
        host = newHost.uid,
        users = [newHost];

  SessionModel.fromMap(Map map)
      : sid = map[SID_PATH],
        playerState = map[STATE_PATH] == null
            ? null
            : PlayerStateModel.fromMap(map[STATE_PATH]),
        queue = SongModel.fromMapList(map[QUEUE_PATH]),
        history = SongModel.fromMapList(map[HISTORY_PATH]),
        host = map[HOST_PATH],
        users = UserModel.fromMapList(map[USERS_PATH]);

  Map<String, dynamic> toMap() {
    return {
      SID_PATH: sid,
      STATE_PATH: playerState?.toMap(),
      QUEUE_PATH: SongModel.toMapList(queue),
      HISTORY_PATH: SongModel.toMapList(history),
      HOST_PATH: host,
      USERS_PATH: UserModel.toMapList(users),
    };
  }

  @override
  bool operator ==(other) =>
      other is SessionModel &&
      other.sid == sid &&
      other.playerState == playerState &&
      listsEqual(other.queue, queue) &&
      listsEqual(other.history, history) &&
      other.host == host &&
      listsEqual(other.users, users);

  @override
  int get hashCode =>
      sid.hashCode ^
      playerState.hashCode ^
      queue.hashCode ^
      history.hashCode ^
      host.hashCode ^
      users.hashCode;
}
