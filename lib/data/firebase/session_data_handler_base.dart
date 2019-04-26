import 'package:yes_music/models/state/session_model.dart';
import 'package:yes_music/models/state/song_model.dart';

abstract class SessionDataHandlerBase {
  /// Gets a [SessionModel] stream for the given [sid].
  Future<Stream<SessionModel>> getSessionModelStream(String sid);

  /// Queues the given [track] for the current session.
  Future queueTrack(String sid, SongModel track);

  /// Likes the track at the given [index] with the given [uid].
  Future likeTrack(String sid, int index, String uid);
}
