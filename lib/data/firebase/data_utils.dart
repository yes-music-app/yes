import 'package:firebase_database/firebase_database.dart';
import 'package:yes_music/models/state/session_model.dart';

/// Checks whether a session with the give [sid] exists in the database.
Future<bool> sessionExists(String sid) async {
  // Get a snapshot of the session.
  final DataSnapshot snapshot = await FirebaseDatabase.instance
      .reference()
      .child(SESSION_PATH)
      .child(sid)
      .once();

  return snapshot?.value != null;
}
