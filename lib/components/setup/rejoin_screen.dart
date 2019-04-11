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
    // Retrieve a reference to the rejoin bloc for this context.
    _rejoinBloc = BlocProvider.of<RejoinBloc>(context);

    // Create a subscription to the bloc's state stream.
    _stateSub = _rejoinBloc.stateStream.listen(
      (RejoinState state) {
        switch (state) {
          case RejoinState.NO_SESSION:
            // If the rejoin bloc was unable to find a session to rejoin, push
            // the choose screen.
            _pushChooseScreen();
            break;
          case RejoinState.SESSION_JOINED:
            // If the rejoin bloc found a session to rejoin, join it.
            _pushMainScreen();
            break;
          default:
            break;
        }
      },
      onError: (e) {
        // If the error is an error that we have handled, retrieve its message.
        String message = e is StateError ? e.message : "errors.unknown";

        // Display an alert to the user telling them that an error has occurred.
        showFailedAlert(
          context,
          FlutterI18n.translate(context, message),
          // When they dismiss the message, push the not rejoined state to the
          // bloc.
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