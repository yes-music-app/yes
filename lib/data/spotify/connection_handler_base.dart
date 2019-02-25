import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/app_remote_bloc.dart';

abstract class ConnectionHandlerBase {
  /// A stream of connection state information from the app remote.
  ValueObservable<SpotifyConnectionState> get stream;

  /// Attempt to connect to the Spotify auth API.
  Future connect();

  /// Attempt to disconnect from the Spotify auth API.
  void disconnect();

  /// Dispose of any resources allocated by this handler.
  void dispose();
}
