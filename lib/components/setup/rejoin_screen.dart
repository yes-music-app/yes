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
          case RejoinState.SESSION_FOUND:
            _requestRejoin();
            break;
          case RejoinState.SESSION_JOINED:
            _pushMainScreen();
            break;
          case RejoinState.SESSION_LEFT:
            _pushChooseScreen();
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

  void _requestRejoin() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            content: SingleChildScrollView(
              child: Text(
                FlutterI18n.translate(
                  context,
                  "rejoin.rejoinPrompt",
                  {
                    "sid": _rejoinBloc.sid,
                  },
                ),
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  FlutterI18n.translate(context, "cancel"),
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  _rejoinBloc.stateSink.add(RejoinState.LEAVING_SESSION);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  FlutterI18n.translate(context, "rejoin.rejoin"),
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  _rejoinBloc.stateSink.add(RejoinState.JOINING_SESSION);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

  void _pushMainScreen() {
    Navigator.of(context).pushReplacementNamed("/main");
  }

  void _pushChooseScreen() {
    Navigator.of(context).pushReplacementNamed("/choose");
  }
}
