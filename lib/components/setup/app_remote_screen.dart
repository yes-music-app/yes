import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/app_remote_bloc.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/components/common/custom_button.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';

class AppRemoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppRemoteBloc bloc = BlocProvider.of<AppRemoteBloc>(context);

    bloc.stream.listen((SpotifyConnectionState state) {
      switch (state) {
        case SpotifyConnectionState.FAILED:
          _showFailedDialog(context, bloc);
          break;
        case SpotifyConnectionState.CONNECTED:
          _pushCreateScreen(context);
          break;
        default:
          break;
      }
    });

    return new Container(
      child: new Center(
        child: new StreamBuilder(
          stream: bloc.stream,
          builder: (
            BuildContext context,
            AsyncSnapshot<SpotifyConnectionState> snapshot,
          ) {
            if (snapshot == null || !snapshot.hasData) {
              return _loadingIndicator();
            }

            switch (snapshot.data) {
              case SpotifyConnectionState.DISCONNECTED:
                bloc.connect();
                return _loadingIndicator();
              default:
                return _loadingIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _loadingIndicator() {
    return new CircularProgressIndicator();
  }

  void _showFailedDialog(BuildContext context, AppRemoteBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) => _failedAlert(context, bloc),
    );
  }

  Widget _failedAlert(BuildContext context, AppRemoteBloc bloc) {
    return new AlertDialog(
      content: new SingleChildScrollView(
        child: new Text(
          FlutterI18n.translate(context, "appRemote.failedInfo"),
          style: Theme.of(context).textTheme.body1,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: new Text(
            FlutterI18n.translate(context, "ok"),
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () {
            bloc.sink.add(SpotifyConnectionState.DISCONNECTED);
            Navigator.of(context).pushNamedAndRemoveUntil(
              "/choose",
              (Route<dynamic> route) => false,
            );
          },
        )
      ],
    );
  }

  void _pushCreateScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed("/create");
  }
}
