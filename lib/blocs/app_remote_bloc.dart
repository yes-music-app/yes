import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';
import 'package:yes_music/data/spotify/spotify_connection_handler.dart';

class AppRemoteBloc implements BlocBase {
  final SpotifyConnectionHandler _connectionHandler;

  ValueObservable<SpotifyConnectionState> get stream =>
      _connectionHandler.connectionSubject.stream;

  StreamSink<SpotifyConnectionState> get sink =>
      _connectionHandler.connectionSubject.sink;

  AppRemoteBloc(this._connectionHandler);

  void connect() {
    _connectionHandler.connect();
  }

  @override
  void dispose() {}
}
