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
  Future<Stream> getSessionModelStream(String sid) async {
    final DatabaseReference sessionReference = _firebase.child(sid);
    final DataSnapshot sessionSnapshot = await sessionReference.once();
    if (sessionSnapshot == null || sessionSnapshot.value == null) {
      throw StateError("errors.session.no_remote_session");
    }

    return sessionReference.onValue.map((Event e) => e.snapshot.value);
  }

  /// Queues the given [track] for the current session.
  Future queueTrack(String sid, String uid, TrackModel track) async {
    // Check to ensure that the session exists.
    final DatabaseReference sessionReference = _firebase.child(sid);
    DataSnapshot snapshot = await sessionReference.once();
    if (snapshot == null || snapshot.value == null) {
      throw StateError("errors.session.no_remote_session");
    }

    // Generate a new reference to the path that we want to access.
    final DatabaseReference itemReference =
        sessionReference.child(QUEUE_KEY).push();
    String qid = itemReference.key;

    // Create a new song model with the received key and push it.
    SongModel song = SongModel(
      qid,
      track,
      uid,
      [uid],
      DateTime.now().millisecondsSinceEpoch,
    );
    itemReference.set(song.toMap()).catchError((e) {
      throw StateError("errors.session.session_write");
    });
  }

  /// Likes the track at the given [qid] with the given [uid].
  @override
  Future likeTrack(String sid, String qid, String uid) async {
    // Get a snapshot of the song.
    final DatabaseReference songReference =
        _firebase.child(sid).child(QUEUE_KEY).child(qid);
    DataSnapshot snapshot = await songReference.once();
    if (snapshot == null) {
      throw StateError("errors.session.no_remote_session");
    }

    // Get a reference to the upvotes list.
    final DatabaseReference upvotesReference = songReference.child(UPVOTES_KEY);
    snapshot = await upvotesReference.once();

    // Change this song's upvotes and then write the changes.
    final List upvotes = List.from(snapshot.value ?? []);
    if (upvotes.contains(uid)) {
      upvotes.remove(uid);
    } else {
      upvotes.add(uid);
    }

    upvotesReference.set(upvotes).catchError((e) {
      throw StateError("errors.session.session_write");
    });
  }

  /// Deletes the track at the given [qid].
  @override
  Future deleteTrack(String sid, String qid) async {
    // Get a snapshot of the song.
    final DatabaseReference songReference =
    _firebase.child(sid).child(QUEUE_KEY).child(qid);
    DataSnapshot snapshot = await songReference.once();
    if (snapshot == null) {
      throw StateError("errors.database.noSong");
    }

    // Deletes the song from the database.
    songReference.remove();
  }
}
