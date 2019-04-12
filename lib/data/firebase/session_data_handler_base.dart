import 'package:yes_music/models/state/song_model.dart';

abstract class SessionDataHandlerBase {
  /// Sets the queue for the current session to [queue].
  Future setQueue(List<SongModel> queue);

  /// Sets the history for the current session to [history].xs
  Future setHistory(List<SongModel> history);
}
