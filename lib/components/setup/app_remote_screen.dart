import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/app_remote_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/failed_alert.dart';
import 'package:yes_music/components/common/loading_indicator.dart';

/// The screen that handles connection with the Spotify app.
class AppRemoteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppRemoteScreen();
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
        case SpotifyConnectionState.CONNECTED:
          _pushCreateScreen();
          break;
        default:
          break;
      }
    }, onError: (e) {
      String message = e is StateError ? e.message : "errors.unknown";
      showFailedAlert(
        context,
        FlutterI18n.translate(context, message),
        () => Navigator.of(context).pushNamedAndRemoveUntil(
              "/choose",
              (Route<dynamic> route) => false,
            ),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
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
