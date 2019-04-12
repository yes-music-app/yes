import 'package:firebase_database/firebase_database.dart';
import 'package:yes_music/data/firebase/data_utils.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/session_data_handler_base.dart';
import 'package:yes_music/data/firebase/session_state_handler.dart';
import 'package:yes_music/models/state/session_model.dart';
import 'package:yes_music/models/state/song_model.dart';

class SessionDataHandler implements SessionDataHandlerBase {
  /// A reference to the root of the Firebase database.
  final DatabaseReference _firebase =
      FirebaseDatabase.instance.reference().child(SESSION_PATH);

  /// A reference to the session state handler for the sid.
  final SessionStateHandler _stateHandler =
      FirebaseProvider().getSessionStateHandler();

  /// Sets the queue for the current session to [queue].
  @override
  Future setQueue(List<SongModel> queue) async {
    await _setItem(QUEUE_PATH, SongModel.toMapList(queue));
    return;
  }

  /// Sets the history for the current session to [history].
  @override
  Future setHistory(List<SongModel> history) async {
    await _setItem(HISTORY_PATH, SongModel.toMapList(history));
    return;
  }

  /// Sets the child of the current session at [path] to [value].
  Future _setItem(String path, dynamic value) async {
    // Get the current sid.
    String sid = _stateHandler.sid();

    // Retrieve a reference to the new session's database path, and check if a
    // session exists there.
    if (!await sessionExists(sid)) {
      throw StateError("errors.session.no_remote_session");
    }

    // Attempt to write the new value to the session database.
    DatabaseReference sessionReference = _firebase.child(sid);
    try {
      sessionReference.child(path).set(value);
    } catch (e) {
      throw StateError("errors.session.session_write");
    }

    return;
  }
}
