import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';
import 'package:yes_music/data/spotify/spotify_connection_handler.dart';

class LoginBloc implements BlocBase {
  final SpotifyConnectionHandler _connectionHandler;

  LoginBloc(this._connectionHandler);

  Stream<SpotifyConnectionState> get connectionState =>
      _connectionHandler.connectionSubject?.stream;

  @override
  void dispose() {}
}
