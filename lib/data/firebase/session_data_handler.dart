import 'package:firebase_database/firebase_database.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/session_data_handler_base.dart';
import 'package:yes_music/models/state/session_model.dart';
import 'package:yes_music/models/state/song_model.dart';

class SessionDataHandler implements SessionDataHandlerBase {
  /// A reference to the root of the Firebase database.
  final DatabaseReference _firebase =
      FirebaseDatabase.instance.reference().child(SESSION_KEY);

  @override
  Future<Stream<SessionModel>> getSessionModelStream() async {
    final String sid =
        FirebaseProvider().getSessionStateHandler().sid(checked: true);

    final DatabaseReference sessionReference = _firebase.child(sid);
    final DataSnapshot sessionSnapshot = await sessionReference.once();
    if (sessionSnapshot == null || sessionSnapshot.value == null) {
      throw StateError("errors.session.no_remote_session");
    }

    return sessionReference.onValue.map<SessionModel>(
      (Event data) => SessionModel.fromMap(data.snapshot.value),
    );
  }

  /// Queues the given [track] for the current session.
  Future queueTrack(SongModel track) async {
    final String sid =
        FirebaseProvider().getSessionStateHandler().sid(checked: true);

    final DatabaseReference sessionReference = _firebase.child(sid);
    DataSnapshot snapshot = await sessionReference.once();
    if (snapshot == null || snapshot.value == null) {
      throw StateError("errors.session.no_remote_session");
    }

    final DatabaseReference queueReference = sessionReference.child(QUEUE_KEY);
    snapshot = await queueReference.once();
    if (snapshot == null) {
      throw StateError("errors.session.no_remote_session");
    }

    List<SongModel> oldQueue = SongModel.fromMapList(snapshot.value);
    oldQueue.add(track);
    queueReference.set(SongModel.toMapList(oldQueue)).catchError((e) {
      throw StateError("errors.session.session_write");
    });
  }
}
