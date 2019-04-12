import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/join_bloc.dart';
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
  JoinBloc bloc;
  StreamSubscription subscription;
  final TextEditingController sidController = TextEditingController();

  @override
  void initState() {
    bloc = BlocProvider.of<JoinBloc>(context);
    subscription = bloc.stream.listen(
      (JoinSessionState state) {
        switch (state) {
          case JoinSessionState.JOINED:
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
          () => bloc.sink.add(JoinSessionState.NOT_JOINED),
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
            stream: bloc.stream,
            builder: (
              BuildContext context,
              AsyncSnapshot<JoinSessionState> snapshot,
            ) {
              if (snapshot == null || !snapshot.hasData || snapshot.hasError) {
                return loadingIndicator();
              }

              switch (snapshot.data) {
                case JoinSessionState.NOT_JOINED:
                  return _getContents();
                default:
                  return loadingIndicator();
              }
            },
          ),
        ),
      ),
      onWillPop: () {
        return Future.value(bloc.stream.value == JoinSessionState.NOT_JOINED);
      },
    );
  }

  @override
  void dispose() {
    subscription.cancel();
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
          controller: sidController,
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
            bloc.sidSink.add(sidController.value.text);
          },
          theme: Theme.of(context),
        ),
      ],
    );
  }

  void _pushMainScreen() {
    Navigator.of(context).pushReplacementNamed("/main");
  }
}
