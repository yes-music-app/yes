import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/session_state_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/custom_button.dart';
import 'package:yes_music/components/common/failed_alert.dart';
import 'package:yes_music/components/common/loading_indicator.dart';

/// The screen that handles a user's attempt to join an in-progress session.
class JoinScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  SessionStateBloc _stateBloc;
  StreamSubscription _stateSub;
  final TextEditingController _sidController = TextEditingController();

  @override
  void initState() {
    _stateBloc = BlocProvider.of<SessionStateBloc>(context);
    _stateSub = _stateBloc.stateStream.listen(
      (SessionState state) {
        switch (state) {
          case SessionState.ACTIVE:
            _pushMainScreen(_stateBloc.sid(checked: true));
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
          () => _stateBloc.stateSink.add(SessionState.AWAITING_SID),
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Center(
          child: StreamBuilder(
            stream: _stateBloc.stateStream,
            builder: (
              BuildContext context,
              AsyncSnapshot<SessionState> snapshot,
            ) {
              if (snapshot == null || !snapshot.hasData || snapshot.hasError) {
                return loadingIndicator();
              }

              switch (snapshot.data) {
                case SessionState.AWAITING_SID:
                  return _getContents();
                default:
                  return loadingIndicator();
              }
            },
          ),
        ),
      ),
      onWillPop: () {
        return Future.value(
          _stateBloc.stateStream.value == SessionState.AWAITING_SID,
        );
      },
    );
  }

  @override
  void dispose() {
    _stateSub.cancel();
    super.dispose();
  }

  Widget _getContents() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          FlutterI18n.translate(context, "join.prompt"),
          style: Theme.of(context).textTheme.body1,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        TextField(
          controller: _sidController,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        CustomButton.withTheme(
          child: Text(
            FlutterI18n.translate(context, "join.join"),
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () {
            _stateBloc.stateSink.add(SessionState.JOINING);
            _stateBloc.sidSink.add(_sidController.value.text);
          },
          theme: Theme.of(context),
        ),
      ],
    );
  }

  void _pushMainScreen(String sid) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      "/main",
      (Route route) => false
    );
  }
}
