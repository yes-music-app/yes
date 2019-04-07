/// A class that handles all Firebase transactions.
abstract class TransactionHandlerBase {
  /// The session ID of the current session.
  String get sid;

  /// Creates a session, generating a session ID for it.
  Future createSession();

  /// Joins the session with the given [sid].
  Future joinSession(String sid);

  /// Leaves the current session.
  Future leaveSession({leaveID});

  /// Finds a session that the current user is already in.
  Future<String> findSession();
}
