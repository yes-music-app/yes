import 'package:rxdart/rxdart.dart';

enum CreateSessionState {
  NOT_CREATED,
  APP_REMOTE_CONNECTING,
  APP_REMOTE_FAILED,
  APP_REMOTE_CONNECTED,
  CREATING,
  CREATED,
  FAILED,
}

enum JoinSessionState {
  NOT_JOINED,
  JOINING,
  JOINED,
  FAILED,
}

/// A class that handles all Firebase transactions.
abstract class TransactionHandlerBase {
  /// The session ID of the current session.
  String get sid;

  /// A [BehaviorSubject] that describes the state of session creation.
  BehaviorSubject<CreateSessionState> get createState;

  /// A [BehaviorSubject] that describes the state of session joining.
  BehaviorSubject<JoinSessionState> get joinState;

  /// Creates a session, generating a new session ID for it.
  void createSession();

  /// Joins the session with the given [sid].
  void joinSession(String sid);

  /// Disposes this handler.
  void dispose();
}
