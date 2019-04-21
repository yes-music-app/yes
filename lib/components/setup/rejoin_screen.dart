import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/session_state_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/failed_alert.dart';
import 'package:yes_music/components/common/loading_indicator.dart';

class RejoinScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RejoinScreenState();
}

class _RejoinScreenState extends State<RejoinScreen> {
  SessionStateBloc _stateBloc;
  StreamSubscription _stateSub;

  @override
  void initState() {
    // Retrieve a reference to the rejoin bloc for this context.
    _stateBloc = BlocProvider.of<SessionStateBloc>(context);

    // Create a subscription to the bloc's state stream.
    _stateSub = _stateBloc.stateStream.listen(
      (SessionState state) {
        switch (state) {
          case SessionState.INACTIVE:
            _stateBloc.stateSink.add(SessionState.REJOINING);
            break;
          case SessionState.CHOOSING:
            _pushChooseScreen();
            break;
          case SessionState.ACTIVE:
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
          () => _stateBloc.stateSink.add(SessionState.CHOOSING),
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
