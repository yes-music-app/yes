import 'package:yes_music/data/spotify/connection_handler_base.dart';
import 'package:yes_music/data/spotify/playback_handler_base.dart';
import 'package:yes_music/data/spotify/spotify_connection_handler.dart';
import 'package:yes_music/data/spotify/spotify_playback_handler.dart';

enum Flavor {
  MOCK,
  REMOTE,
}

class SpotifyProvider {
  Flavor _flavor;
  PlaybackHandlerBase _playbackHandler;
  ConnectionHandlerBase _connectionHandler;

  /// A singleton instance of the Spotify provider.
  static final SpotifyProvider _instance = new SpotifyProvider._internal();

  factory SpotifyProvider() => _instance;

  SpotifyProvider._internal();

  /// Sets the [Flavor] to use when making Spotify requests.
  void setFlavor(Flavor flavor) {
    _flavor = flavor;
  }

  PlaybackHandlerBase getPlaybackHandler() {
    switch (_flavor) {
      case Flavor.REMOTE:
        if(_playbackHandler == null) {
          _playbackHandler = new SpotifyPlaybackHandler();
        }

        return _playbackHandler;
        break;
      default:
        throw new StateError("Spotify provider flavor not set");
        break;
    }
  }

  ConnectionHandlerBase getConnectionHandler() {
    switch (_flavor) {
      case Flavor.REMOTE:
        if(_connectionHandler == null) {
          _connectionHandler = new SpotifyConnectionHandler();
        }

        return _connectionHandler;
        break;
      default:
        throw new StateError("Spotify provider flavor not set");
        break;
    }
  }
}
