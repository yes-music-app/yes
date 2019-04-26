import 'package:yes_music/models/spotify/track_model.dart';
import 'package:yes_music/models/state/session_model.dart';

abstract class SessionDataHandlerBase {
  /// Gets a [SessionModel] stream for the given [sid].
  Future<Stream<SessionModel>> getSessionModelStream(String sid);

  /// Queues the given [track] for the current session.
  Future queueTrack(String sid, String uid, TrackModel track);

  /// Likes the track at the given [qid] with the given [uid].
  Future likeTrack(String sid, String qid, String uid);
}
