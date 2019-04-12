
import 'package:firebase_database/firebase_database.dart';

/// A reference to the root of the Firebase database.
final DatabaseReference _firebase = FirebaseDatabase.instance.reference();

/// Checks whether a session with the give [sid] exists in the database.
Future<bool> sessionExists(String sid) async {
  // Get a snapshot of the session.
  final DataSnapshot snapshot = await _firebase.child(sid).once();

  return snapshot?.value != null;
}