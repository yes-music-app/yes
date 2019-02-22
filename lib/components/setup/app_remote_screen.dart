import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/app_remote_bloc.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/components/common/failed_alert.dart';
import 'package:yes_music/components/common/loading_indicator.dart';

class AppRemoteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AppRemoteScreen();
}

class _AppRemoteScreen extends State<AppRemoteScreen> {
  AppRemoteBloc bloc;
  StreamSubscription subscription;

  @override
  void initState() {
    bloc = BlocProvider.of<AppRemoteBloc>(context);

    subscription = bloc.stream.listen((SpotifyConnectionState state) {
      switch (state) {
        case SpotifyConnectionState.DISCONNECTED:
          bloc.sink.add(SpotifyConnectionState.CONNECTING);
          break;
        case SpotifyConnectionState.FAILED:
          showFailedAlert(
            context,
            FlutterI18n.translate(context, "appRemote.failedInfo"),
            () => Navigator.of(context).pushNamedAndRemoveUntil(
                  "/choose",
                  (Route<dynamic> route) => false,
                ),
          );
          break;
        case SpotifyConnectionState.CONNECTED:
          _pushCreateScreen();
          break;
        default:
          break;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: loadingIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void _pushCreateScreen() {
    Navigator.of(context).pushReplacementNamed("/create");
  }
}
