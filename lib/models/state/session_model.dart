import 'package:yes_music/helpers/list_utils.dart';
import 'package:yes_music/models/spotify/player_state_model.dart';
import 'package:yes_music/models/spotify/token_model.dart';
import 'package:yes_music/models/state/song_model.dart';
import 'package:yes_music/models/state/user_model.dart';

const String SESSION_KEY = "sessions";
const String SID_KEY = "sid";
const String STATE_KEY = "playerState";
const String QUEUE_KEY = "queue";
const String HISTORY_KEY = "history";
const String HOST_KEY = "host";
const String USERS_KEY = "users";
const String TOKENS_KEY = "tokens";

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

  /// The tokens to be used for this session.
  final TokenModel tokens;

  SessionModel.empty(this.sid, UserModel newHost, this.tokens)
      : playerState = null,
        queue = [],
        history = [],
        host = newHost.uid,
        users = [newHost];

  SessionModel.fromMap(Map map)
      : sid = map[SID_KEY],
        playerState = map[STATE_KEY] == null
            ? null
            : PlayerStateModel.fromMap(map[STATE_KEY]),
        queue = SongModel.fromMapOfMaps(map[QUEUE_KEY]),
        history = SongModel.fromMapOfMaps(map[HISTORY_KEY]),
        host = map[HOST_KEY],
        users = UserModel.fromMapList(map[USERS_KEY]),
        tokens = TokenModel.fromMap(map[TOKENS_KEY]);

  Map<String, dynamic> toMap() {
    return {
      SID_KEY: sid,
      STATE_KEY: playerState?.toMap(),
      QUEUE_KEY: SongModel.toMapList(queue),
      HISTORY_KEY: SongModel.toMapList(history),
      HOST_KEY: host,
      USERS_KEY: UserModel.toMapList(users),
      TOKENS_KEY: tokens?.toMap(),
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
      listsEqual(other.users, users) &&
      other.tokens == tokens;

  @override
  int get hashCode =>
      sid.hashCode ^
      playerState.hashCode ^
      queue.hashCode ^
      history.hashCode ^
      host.hashCode ^
      users.hashCode ^
      tokens.hashCode;
}
