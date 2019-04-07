import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/rejoin_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/failed_alert.dart';
import 'package:yes_music/components/common/loading_indicator.dart';

class RejoinScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RejoinScreenState();
}

class _RejoinScreenState extends State<RejoinScreen> {
  RejoinBloc _rejoinBloc;
  StreamSubscription _stateSub;

  @override
  void initState() {
    _rejoinBloc = BlocProvider.of<RejoinBloc>(context);
    _stateSub = _rejoinBloc.stateStream.listen(
      (RejoinState state) {
        switch (state) {
          case RejoinState.NO_SESSION:
            _pushChooseScreen();
            break;
          case RejoinState.SESSION_JOINED:
            _pushMainScreen();
            break;
          default:
            break;
        }
      },
      onError: (e) {
        String message = e is StateError ? e.message : "errors.unknown";
        showFailedAlert(
          context,
          FlutterI18n.translate(context, message),
          () => _rejoinBloc.stateSink.add(RejoinState.NOT_REJOINED),
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loadingIndicator();
  }

  @override
  void dispose() {
    _stateSub.cancel();
    super.dispose();
  }

  void _pushMainScreen() {
    Navigator.of(context).pushReplacementNamed("/main");
  }

  void _pushChooseScreen() {
    Navigator.of(context).pushReplacementNamed("/choose");
  }
}
