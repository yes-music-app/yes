import 'package:firebase_database/firebase_database.dart';
import 'package:yes_music/data/firebase/session_data_handler_base.dart';
import 'package:yes_music/models/state/session_model.dart';
import 'package:yes_music/models/state/song_model.dart';

class SessionDataHandler implements SessionDataHandlerBase {
  /// A reference to the root of the Firebase database.
  final DatabaseReference _firebase =
  FirebaseDatabase.instance.reference().child(SESSION_KEY);

  @override
  Future<Stream<SessionModel>> getSessionModelStream(String sid) async {
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
  Future queueTrack(String sid, SongModel track) async {
    // Check to ensure that the session exists.
    final DatabaseReference sessionReference = _firebase.child(sid);
    DataSnapshot snapshot = await sessionReference.once();
    if (snapshot == null || snapshot.value == null) {
      throw StateError("errors.session.no_remote_session");
    }

    // Get a snapshot of the queue.
    final DatabaseReference queueReference = _firebase.child(sid).child(
        QUEUE_KEY);
    snapshot = await queueReference.once();
    if (snapshot == null) {
      throw StateError("errors.session.no_remote_session");
    }

    // Add the song to the old queue and then push the changes.
    List<SongModel> oldQueue = SongModel.fromMapList(snapshot.value);
    oldQueue.add(track);
    queueReference.set(SongModel.toMapList(oldQueue)).catchError((e) {
      throw StateError("errors.session.session_write");
    });
  }

  /// Likes the track at the given [index] with the given [uid].
  @override
  Future likeTrack(String sid, int index, String uid) async {
    // Check to ensure that the session exists.
    final DatabaseReference sessionReference = _firebase.child(sid);
    DataSnapshot snapshot = await sessionReference.once();
    if (snapshot == null || snapshot.value == null) {
      throw StateError("errors.session.no_remote_session");
    }

    // Get a snapshot of the queue.
    final DatabaseReference queueReference = _firebase.child(sid).child(
        QUEUE_KEY);
    snapshot = await queueReference.once();
    if (snapshot == null) {
      throw StateError("errors.session.no_remote_session");
    }

    // Change this song's upvotes and then write the changes.
    final List<SongModel> oldQueue = SongModel.fromMapList(snapshot.value);
    final SongModel oldModel = oldQueue[index];
    final List<String> oldUpvotes = oldModel.upvotes;
    if (oldUpvotes.contains(uid)) {
      oldUpvotes.remove(uid);
    } else {
      oldUpvotes.add(uid);
    }

    oldQueue[index] = SongModel(oldModel.track, oldModel.uid, oldUpvotes);
    queueReference.set(SongModel.toMapList(oldQueue)).catchError((e) {
      throw StateError("errors.session.session_write");
    });
  }
}
