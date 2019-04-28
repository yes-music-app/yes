import 'package:yes_music/data/flavor.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';
import 'package:yes_music/data/spotify/data_handler_base.dart';
import 'package:yes_music/data/spotify/spotify_connection_handler.dart';
import 'package:yes_music/data/spotify/spotify_data_handler.dart';

class SpotifyProvider {
  Flavor _flavor = Flavor.REMOTE;
  DataHandlerBase _dataHandler;
  ConnectionHandlerBase _connectionHandler;

  /// A singleton instance of the Spotify provider.
  static final SpotifyProvider _instance = SpotifyProvider._internal();

  factory SpotifyProvider() => _instance;

  SpotifyProvider._internal();

  /// Sets the [Flavor] to use when making Spotify requests.
  void setFlavor(Flavor flavor) {
    _flavor = flavor;
  }

  DataHandlerBase getDataHandler() {
    switch (_flavor) {
      case Flavor.REMOTE:
        if (_dataHandler == null) {
          _dataHandler = SpotifyDataHandler();
        }

        return _dataHandler;
        break;
      case Flavor.MOCK:
        throw UnimplementedError("Mock data handler not yet implemented.");
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
      case Flavor.MOCK:
        throw UnimplementedError(
            "Mock connection handler not yet implemented.");
      default:
        throw StateError("Spotify provider flavor not set");
        break;
    }
  }
}
