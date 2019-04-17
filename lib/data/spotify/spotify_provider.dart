import 'package:yes_music/data/flavor.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';
import 'package:yes_music/data/spotify/playback_handler_base.dart';
import 'package:yes_music/data/spotify/spotify_token_handler.dart';
import 'package:yes_music/data/spotify/spotify_connection_handler.dart';
import 'package:yes_music/data/spotify/spotify_playback_handler.dart';
import 'package:yes_music/data/spotify/token_handler_base.dart';

class SpotifyProvider {
  Flavor _flavor = Flavor.REMOTE;
  PlaybackHandlerBase _playbackHandler;
  ConnectionHandlerBase _connectionHandler;
  TokenHandlerBase _tokenHandler;

  /// A singleton instance of the Spotify provider.
  static final SpotifyProvider _instance = SpotifyProvider._internal();

  factory SpotifyProvider() => _instance;

  SpotifyProvider._internal();

  /// Sets the [Flavor] to use when making Spotify requests.
  void setFlavor(Flavor flavor) {
    _flavor = flavor;
  }

  PlaybackHandlerBase getPlaybackHandler() {
    switch (_flavor) {
      case Flavor.REMOTE:
        if (_playbackHandler == null) {
          _playbackHandler = SpotifyPlaybackHandler();
        }

        return _playbackHandler;
        break;
      default:
        throw StateError("Spotify provider flavor not set");
        break;
    }
  }

  ConnectionHandlerBase getConnectionHandler() {
    switch (_flavor) {
      case Flavor.REMOTE:
        if (_connectionHandler == null) {
          _connectionHandler = SpotifyConnectionHandler();
        }

        return _connectionHandler;
        break;
      default:
        throw StateError("Spotify provider flavor not set");
        break;
    }
  }

  TokenHandlerBase getTokenHandler() {
    switch (_flavor) {
      case Flavor.REMOTE:
        if (_tokenHandler == null) {
          _tokenHandler = SpotifyTokenHandler();
        }

        return _tokenHandler;
      case Flavor.MOCK:
        throw UnimplementedError("Mock token handler not yet implemented.");
      default:
        throw StateError("Firebase provider flavor not set");
    }
  }
}
