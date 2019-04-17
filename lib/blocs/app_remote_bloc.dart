import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';
import 'package:yes_music/data/spotify/spotify_provider.dart';

/// An enumeration of the potential states that a app remote connection
/// operation can be in.
enum SpotifyConnectionState {
  DISCONNECTED,
  CONNECTING,
  CONNECTED,
}

/// A bloc that handles connecting to the Spotify Remote API.
class AppRemoteBloc implements BlocBase {
  /// The [ConnectionHandlerBase] that performs the connection operation.
  final ConnectionHandlerBase _connectionHandler =
      SpotifyProvider().getConnectionHandler();

  /// An [BehaviorSubject] that publishes the current connection state.
  BehaviorSubject<SpotifyConnectionState> _connectionState =
      BehaviorSubject.seeded(SpotifyConnectionState.DISCONNECTED);

  ValueObservable<SpotifyConnectionState> get stream => _connectionState.stream;

  StreamSink<SpotifyConnectionState> get sink => _connectionState.sink;

  /// A subscription to the connection state.
  StreamSubscription<SpotifyConnectionState> _sub;

  /// Creates a new [AppRemoteBloc] and begins listening for state changes.
  AppRemoteBloc() {
    _sub = _connectionState.listen((SpotifyConnectionState state) {
      switch (state) {
        case SpotifyConnectionState.CONNECTING:
          _connect();
          break;
        default:
          break;
      }
    });
  }

  /// Connects to the Spotify app remote.
  Future _connect() async {
    _connectionHandler.connect().then((_) {
      _connectionState.add(SpotifyConnectionState.CONNECTED);
    }).catchError((e) {
      _connectionState.addError(StateError("errors.remote.connect"));
    });
  }

  @override
  void dispose() async {
    await _sub.cancel();
    _connectionState.close();
  }
}
