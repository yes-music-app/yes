import 'package:yes_music/models/state/session_model.dart';

/// A class that handles session transactions.
abstract class SessionStateHandlerBase {
  /// A public getter that returns the current SID.
  String sid({bool checked});

  /// Creates a session from the given session model.
  Future createSession(SessionModel sessionModel);

  /// Joins a session that is already in progress.
  Future joinSession(String sid);

  /// Attempts to rejoin a cached session.
  Future<bool> rejoinSession();

  /// Attempts to leave the currently joined session.
  Future leaveSession();
}
