import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/data/spotify/spotify_connection_handler.dart';

enum SpotifyConnectionState {
  DISCONNECTED,
  CONNECTING,
  CONNECTED,
  FAILED,
}

class AppRemoteBloc implements BlocBase {
  final SpotifyConnectionHandler _connectionHandler;
  StreamSubscription<SpotifyConnectionState> _subjectSub;

  /// An rxdart [BehaviorSubject] that publishes the current connection state.
  BehaviorSubject<SpotifyConnectionState> _connectionSubject =
      new BehaviorSubject(seedValue: SpotifyConnectionState.DISCONNECTED);

  ValueObservable<SpotifyConnectionState> get stream =>
      _connectionSubject.stream;

  StreamSink<SpotifyConnectionState> get sink => _connectionSubject.sink;

  AppRemoteBloc(this._connectionHandler) {
    _subjectSub = _connectionSubject.listen((SpotifyConnectionState state) {
      switch (state) {
        case SpotifyConnectionState.DISCONNECTED:
          _connect();
          break;
        default:
          break;
      }
    });
  }

  void _connect() {
    _connectionHandler.connect().then((bool value) {
      if(value) {
        _connectionSubject.add(SpotifyConnectionState.CONNECTED);
      } else {
        _connectionSubject.add(SpotifyConnectionState.FAILED);
      }
    });
    _connectionSubject.add(SpotifyConnectionState.CONNECTING);
  }

  @override
  void dispose() async {
    await _subjectSub.cancel();
    _connectionSubject.close();
  }
}
