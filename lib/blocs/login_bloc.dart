import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';
import 'package:yes_music/data/spotify/spotify_connection_handler.dart';

/// A bloc handling the state of the login process into Firebase.
class LoginBloc implements BlocBase {
  final SpotifyConnectionHandler _connectionHandler;

  BehaviorSubject<SpotifyConnectionState> get connectionSubject =>
      _connectionHandler.connectionSubject;

  LoginBloc(this._connectionHandler);

  @override
  void dispose() {
    _connectionHandler.dispose();
  }
}
