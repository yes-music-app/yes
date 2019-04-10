import 'package:firebase_database/firebase_database.dart';

/// A class that handles session transactions.
abstract class SessionHandlerBase {
  /// Create a subscription to the session's state.
  Future<Stream<Event>> sessionStateSubscribe(String sid);
}