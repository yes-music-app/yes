import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yes_music/data/firebase/auth_handler_base.dart';
import 'package:yes_music/helpers/data_utils.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/session_state_handler_base.dart';
import 'package:yes_music/models/state/session_model.dart';
import 'package:yes_music/models/state/user_model.dart';

/// A class that handles the exchange of data with Firebase regarding the
/// session state.
class SessionStateHandler implements SessionStateHandlerBase {
  /// A reference to the root of the Firebase database.
  final DatabaseReference _firebase =
      FirebaseDatabase.instance.reference().child(SESSION_KEY);

  /// A reference to the Firebase auth handler so that we can retrieve the uid.
  final AuthHandlerBase _authHandler = FirebaseProvider().getAuthHandler();

  /// The session ID of the currently joined session. This ID should be null if
  /// the user is not currently in a session.
  String _sid;

  /// A public getter that returns the current SID.
  @override
  String sid({bool checked = true}) {
    // Get the current sid.
    String sid = _sid?.toUpperCase();

    if (checked && (sid == null || sid.isEmpty)) {
      throw StateError("errors.database.sid");
    }

    return sid;
  }

  /// A private getter for the user's Firebase ID.
  Future<String> _uid({bool checked = true}) async =>
      await _authHandler.uid(checked: checked);

  /// Sets the SID and commits the SID to the system memory for rejoin attempts.
  Future _setSID(String sid) async {
    // Retrieve the uid to set the sid for.
    String uid = await _uid();

    // Ensure that the SID that we are writing is upper cased.
    _sid = sid?.toUpperCase();

    // Persist the new SID so that it can be accessed the next time we load
    // into the app.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(uid, _sid);
  }

  /// Creates a session from the given session model.
  @override
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

    // Check if the session already exists.
    if (await sessionExists(sessionModel.sid)) {
      throw StateError("errors.session.create_exists");
    }

    // Attempt to write the new session to the session database.
    DatabaseReference sessionReference = _firebase.child(sessionModel.sid);
    sessionReference.set(sessionModel.toMap()).catchError((e) {
      throw StateError("errors.session.session_write");
    });

    // If we have successfully joined the session, set our local SID.
    await _setSID(sessionModel.sid);
    // TODO: Initialize output streams here.
    return;
  }

  /// Joins a session that is already in progress.
  @override
  Future joinSession(String sid) async {
    // Case the SID.
    sid = sid.toUpperCase();

    // Acquire the current UID.
    String uid = await _uid();

    // If the session ID is not valid, throw an error.
    if (sid == null || sid.isEmpty) {
      throw StateError("errors.session.join_sid");
    }

    // Ensure that the session exists.
    if (!await sessionExists(sid)) {
      throw StateError("errors.session.join_exists");
    }

    // Set a path that points to the new user's entry in the database.
    final String path = USERS_KEY + "/" + uid;

    // Attempt to write the new value to the session database.
    UserModel model = UserModel.empty(uid);
    _firebase.child(sid).child(path).set(model.toMap()).catchError((e) {
      throw StateError("errors.session.session_write");
    });

    // Set the SID to the SID that was joined.
    await _setSID(sid);
    // TODO: Initialize output streams here.
    return;
  }

  /// Attempts to rejoin a cached session.
  @override
  Future<bool> rejoinSession() async {
    // Acquire the current UID.
    String uid = await _uid();

    // Retrieve an old SID from the shared preferences, if it exists.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String oldSID = prefs.getString(uid);

    // If there is no old session ID, return false.
    if (oldSID == null || oldSID.isEmpty) {
      return false;
    }

    // If the session doesn't exist, return false.
    if (!await sessionExists(oldSID)) {
      return false;
    }

    // If the user is not part of the session, return false.
    DatabaseReference userReference =
        _firebase.child(oldSID).child(USERS_KEY).child(uid);
    DataSnapshot snapshot = await userReference.once();
    if (snapshot == null || snapshot.value == null) {
      return false;
    }

    // Rejoin the session.
    await _setSID(oldSID);
    // TODO: Initialize output streams here.
    return true;
  }

  /// Attempts to leave the currently joined session.
  @override
  Future leaveSession() async {
    // Acquire the current UID.
    String uid = await _uid();

    // Check to ensure that the session exists.
    if (!await sessionExists(_sid)) {
      throw StateError("errors.session.no_remote_session");
    }

    // Get a reference to the session.
    DatabaseReference sessionReference = _firebase.child(_sid);

    // Check to see whether the user is the host of the session.
    DataSnapshot snapshot = await sessionReference.child(HOST_KEY).once();
    if (snapshot?.value == uid) {
      // If the user is the host, delete the entire session.
      await sessionReference.remove().catchError((e) {
        throw StateError("errors.database.operation");
      });

      await _setSID(null);
      return;
    }

    // Check to ensure the user is in the session.
    DatabaseReference userReference =
        sessionReference.child(USERS_KEY).child(uid);
    snapshot = await userReference.once();
    if (snapshot == null || snapshot.value == null) {
      throw StateError("errors.session.no_remote_session");
    }

    // Remove the user from the session.
    await userReference.remove().catchError((e) {
      throw StateError("errors.database.operation");
    });

    await _setSID(null);
    // TODO: Close output streams here.
    return;
  }
}
