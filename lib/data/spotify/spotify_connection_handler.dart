import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/app_remote_bloc.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';

class SpotifyConnectionHandler implements ConnectionHandlerBase {
  static const MethodChannel channel =
      const MethodChannel("yes.yesmusic/connection");

  /// An rxdart [BehaviorSubject] that publishes the current connection state.
  BehaviorSubject<SpotifyConnectionState> _connectionSubject =
      new BehaviorSubject(seedValue: SpotifyConnectionState.DISCONNECTED);

  @override
  ValueObservable<SpotifyConnectionState> get stream =>
      _connectionSubject.stream;

  @override
  Future<bool> connect() async {
    return await channel.invokeMethod('connect');
  }

  @override
  void disconnect() {
    channel.invokeMethod("disconnect");
  }

  @override
  void dispose() {
    _connectionSubject.close();
  }
}
