import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/session_state_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/failed_alert.dart';
import 'package:yes_music/components/common/loading_indicator.dart';

/// The screen that handles connection with the Spotify app.
class SpotifyConnectScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SpotifyConnectScreenState();
}

class _SpotifyConnectScreenState extends State<SpotifyConnectScreen> {
  SessionStateBloc _stateBloc;
  StreamSubscription _stateSub;

  @override
  void initState() {
    _stateBloc = BlocProvider.of<SessionStateBloc>(context);
    _stateSub = _stateBloc.stateStream.listen((SessionState state) {
      switch (state) {
        case SessionState.AWAITING_TOKENS:
          _stateBloc.stateSink.add(SessionState.AWAITING_CONNECTION);
          break;
        case SessionState.AWAITING_CONNECTION:
          _stateBloc.tokenSink.add(null);
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
        _pushChooseScreen,
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
    _stateSub.cancel();
    super.dispose();
  }

  void _pushCreateScreen() {
    Navigator.of(context).pushReplacementNamed("/create");
  }

  void _pushChooseScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      "/choose",
      (Route<dynamic> route) => false,
    );
  }
}
