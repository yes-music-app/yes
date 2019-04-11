import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yes_music/data/firebase/session_handler_base.dart';
import 'package:yes_music/models/state/session_model.dart';
import 'package:yes_music/models/state/song_model.dart';
import 'package:yes_music/models/state/user_model.dart';

/// A class that handles the exchange of data with Firebase regarding the
/// session state.
class FirebaseSessionHandler implements SessionHandlerBase {
  /// A reference to the root of the Firebase database.
  final DatabaseReference _firebase = FirebaseDatabase.instance.reference();

  /// The session ID of the currently joined session. This ID should be null if
  /// the user is not currently in a session.
  String _sid;

  /// A public getter that returns the current SID.
  String get sid => _sid;

  /// Sets the SID and commits the SID to the system memory for rejoin attempts.
  Future _setSid(String sid, String uid) async {
    // Check to ensure that we have a valid SID and UID.
    if (sid == null || sid.isEmpty || uid == null || uid.isEmpty) {
      throw StateError("errors.database.uid");
    }

    // Ensure that the SID that we are writing is upper cased.
    _sid = sid?.toUpperCase();

    // Persist the new SID so that it can be accessed the next time we load
    // into the app.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(uid, _sid);
  }

  /// Creates a session from the given session model.
  Future createSession(final SessionModel sessionModel) async {
    // If we are already in a session, throw an error.
    if (_sid != null && _sid.isNotEmpty) {
      throw StateError("errors.session.already_joined");
    }

    // If the session model is incomplete, throw an error.
    if (sessionModel == null ||
        sessionModel.sid == null ||
        sessionModel.sid.isEmpty ||
        sessionModel.host == null ||
        sessionModel.host.isEmpty ||
        sessionModel.users == null ||
        sessionModel.users.isEmpty) {
      throw StateError("errors.session.create_malformed");
    }

    // Retrieve a reference to the new session's database path, and check if a
    // session already exists there.
    DatabaseReference sessionReference = _firebase.child(sessionModel.sid);
    DataSnapshot sessionSnap = await sessionReference.once();
    if (sessionSnap?.value != null) {
      throw StateError("errors.session.create_exists");
    }

    // Attempt to write the new session to the session database.
    try {
      sessionReference.set(sessionModel.toMap());
    } catch (e) {
      throw StateError("errors.session.session_write");
    }

    // If we have successfully joined the session, set our local SID.
    await _setSid(sessionModel.sid, sessionModel.host);
    return;
  }

  /// Joins a session that is already in progress.
  Future joinSession(String sid, UserModel user) async {
    // If the session ID is not valid, throw an error.
    if (sid == null || sid.isEmpty) {
      throw StateError("errors.session.join_sid");
    }

    // Set the SID to the SID that is to be joined.
    await _setSid(sid, user.uid);

    // Attempt to write the new user to the session database.
    try {
      _setItem(USERS_PATH + "/" + user.uid, user.toMap());
    } catch (e) {
      await _setSid(null, user.uid);
      throw e;
    }

    return;
  }

  /// Sets the queue for the current session.
  Future setQueue(List<SongModel> queue) async {
    await _setItem(QUEUE_PATH, SongModel.toMapList(queue));
    return;
  }

  /// Sets the history for the current session.
  Future setHistory(List<SongModel> history) async {
    await _setItem(HISTORY_PATH, SongModel.toMapList(history));
    return;
  }

  /// Sets an attribute of a session.
  Future _setItem(String path, dynamic value) async {
    // If we are not in a session, throw an error.
    if (_sid == null || _sid.isEmpty) {
      throw StateError("errors.session.no_local_session");
    }

    // Retrieve a reference to the new session's database path, and check if a
    // session exists there.
    DatabaseReference sessionReference = _firebase.child(_sid);
    DataSnapshot sessionSnap = await sessionReference.once();
    if (sessionSnap?.value == null) {
      throw StateError("errors.session.no_remote_session");
    }

    // Attempt to write the new value to the session database.
    try {
      sessionReference.child(path).set(value);
    } catch (e) {
      throw StateError("errors.session.session_write");
    }

    return;
  }
}
