import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/data/spotify/playback_handler_base.dart';
import 'package:yes_music/data/spotify/spotify_provider.dart';
import 'package:yes_music/models/spotify/player_state_model.dart';
import 'package:yes_music/models/state/song_model.dart';
import 'package:yes_music/models/state/user_model.dart';

class SessionBloc implements BlocBase {
  final PlaybackHandlerBase _playbackHandler;

  BehaviorSubject<PlayerStateModel> get playerState =>
      _playbackHandler.playerStateSubject;

  List<SongModel> songQueue;

  List<SongModel> songHistory;

  BehaviorSubject<UserModel> get userModel => null;

  SessionBloc() : _playbackHandler = new SpotifyProvider().getPlaybackHandler();

  void resume() {
    _playbackHandler.resume();
  }

  void pause() {
    _playbackHandler.pause();
  }

  void skipNext() {
    _playbackHandler.skipNext();
  }

  void skipPrevious() {
    _playbackHandler.skipPrevious();
  }

  void seekTo(int position) {
    _playbackHandler.seekTo(position);
  }

  void play(String trackUri) {
    _playbackHandler.play(trackUri);
  }

  void queue(String trackUri) {
    _playbackHandler.queue(trackUri);
  }

  @override
  void dispose() {
    _playbackHandler.dispose();
  }
}
