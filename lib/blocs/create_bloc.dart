import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/data/firebase/firebase_transaction_handler.dart';
import 'package:yes_music/data/firebase/transaction_handler_base.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';
import 'package:yes_music/data/spotify/spotify_connection_handler.dart';

class CreateBloc implements BlocBase {
  final SpotifyConnectionHandler _connectionHandler;
  final FirebaseTransactionHandler _transactionHandler;

  ValueObservable<SpotifyConnectionState> get connectionStream =>
      _connectionHandler.connectionSubject.stream;

  StreamSink<SpotifyConnectionState> get connectionSink =>
      _connectionHandler.connectionSubject.sink;

  ValueObservable<CreateSessionState> get transactionStream =>
      _transactionHandler.createState.stream;

  CreateBloc(this._connectionHandler, this._transactionHandler);

  void connectSpotify() {
    _connectionHandler.connect();
  }

  void createSession() {
    _transactionHandler.createSession();
  }

  @override
  void dispose() {}
}
