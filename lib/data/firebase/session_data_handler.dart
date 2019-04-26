import 'package:firebase_database/firebase_database.dart';
import 'package:yes_music/data/firebase/session_data_handler_base.dart';
import 'package:yes_music/models/spotify/track_model.dart';
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
  Future queueTrack(String sid, String uid, TrackModel track) async {
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

    // Generate a new reference to the path that we want to access.
    final DatabaseReference itemReference = queueReference.push();
    String qid = itemReference.key;

    // Create a new song model with the received key and push it.
    SongModel song = SongModel(qid, track, uid, [uid]);
    itemReference.set(song.toMap()).catchError((e) {
      throw StateError("errors.session.session_write");
    });
  }

  /// Likes the track at the given [qid] with the given [uid].
  @override
  Future likeTrack(String sid, String qid, String uid) async {
    // Check to ensure that the session exists.
    final DatabaseReference sessionReference = _firebase.child(sid);
    DataSnapshot snapshot = await sessionReference.once();
    if (snapshot == null || snapshot.value == null) {
      throw StateError("errors.session.no_remote_session");
    }

    // Get a snapshot of the queue.
    final DatabaseReference queueReference = sessionReference.child(
        QUEUE_KEY);
    snapshot = await queueReference.once();
    if (snapshot == null) {
      throw StateError("errors.session.no_remote_session");
    }

    // Get a snapshot of the song.
    final DatabaseReference songReference = queueReference.child(qid);
    snapshot = await songReference.once();
    if (snapshot == null) {
      throw StateError("errors.session.no_remote_session");
    }

    // Change this song's upvotes and then write the changes.
    final SongModel oldModel = SongModel.fromMap(snapshot.value);
    final List<String> upvotes = oldModel.upvotes;
    if (upvotes.contains(uid)) {
      upvotes.remove(uid);
    } else {
      upvotes.add(uid);
    }

    songReference.set(SongModel(oldModel.qid, oldModel.track, oldModel.uid)).catchError((e) {
      throw StateError("errors.session.session_write");
    });
  }
}
