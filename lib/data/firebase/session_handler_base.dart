import 'package:firebase_database/firebase_database.dart';

/// A class that handles session transactions.
abstract class SessionHandlerBase {
  /// Create a subscription to the session's state.
  Future<Stream<Event>> sessionStateSubscribe(String sid);

  /// Gets a stream of the session ID of the given session.
  Future<Stream<Event>> getSIDStream(String sid);

  /// Gets a stream of the host UID of the given session.
  Future<Stream<Event>> getHostStream(String sid);
}
