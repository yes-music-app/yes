import 'package:yes_music/models/state/session_model.dart';
import 'package:yes_music/models/state/song_model.dart';
import 'package:yes_music/models/state/user_model.dart';

/// A class that handles session transactions.
abstract class SessionHandlerBase {
  /// A public getter that returns the current SID.
  String get sid;

  /// Creates a session from the given session model.
  Future createSession(SessionModel sessionModel);

  /// Joins a session that is already in progress.
  Future joinSession(String sid, UserModel user);

  /// Attempts to rejoin a cached session for the user with the given [uid].
  Future<bool> rejoinSession(String uid);

  /// Sets the queue for the current session to [queue].
  Future setQueue(List<SongModel> queue);

  /// Sets the history for the current session to [history].
  Future setHistory(List<SongModel> history);
}
