/// A class that handles all Firebase transactions.
abstract class TransactionHandlerBase {
  /// The session ID of the current session.
  String get sid;

  /// Creates a session, generating a session ID for it.
  Future<bool> createSession();

  /// Joins the session with the given [sid].
  Future joinSession(String sid);
}
