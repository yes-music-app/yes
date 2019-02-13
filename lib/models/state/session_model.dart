import 'package:yes_music/models/spotify/player_state_model.dart';
import 'package:yes_music/models/state/song_model.dart';
import 'package:yes_music/models/state/user_model.dart';

/// A session of users.
class SessionModel {
  /// The current player state.
  final PlayerStateModel _playerState;

  PlayerStateModel get playerState => _playerState;

  /// The current queue of upcoming songs.
  final List<SongModel> _queue;

  List<SongModel> get queue => _queue;

  /// The history of songs that have been played.
  final List<SongModel> _history;

  List<SongModel> get history => _history;

  /// The list of current users.
  final List<UserModel> _users;

  List<UserModel> get users => _users;

  SessionModel(this._playerState, this._queue, this._history, this._users);
}
