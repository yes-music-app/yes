import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/create_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/custom_button.dart';
import 'package:yes_music/components/common/failed_alert.dart';
import 'package:yes_music/components/common/loading_indicator.dart';

/// The screen that allows a user to create a new session.
class CreateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CreateScreen();
}

class _CreateScreen extends State<CreateScreen> {
  CreateBloc bloc;
  StreamSubscription subscription;

  @override
  void initState() {
    bloc = BlocProvider.of<CreateBloc>(context);

    subscription = bloc.stream.listen((CreateSessionState state) {
      switch (state) {
        case CreateSessionState.NOT_CREATED:
          bloc.sink.add(CreateSessionState.CREATING);
          break;
        case CreateSessionState.FAILED:
          showFailedAlert(
            context,
            FlutterI18n.translate(context, "create.failedInfo"),
            () => Navigator.of(context).pushNamedAndRemoveUntil(
                  "/choose",
                  (Route<dynamic> route) => false,
                ),
          );
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
        child: new StreamBuilder(
          stream: bloc.stream,
          builder: (
            BuildContext context,
            AsyncSnapshot<CreateSessionState> snapshot,
          ) {
            if (snapshot == null || !snapshot.hasData) {
              return loadingIndicator();
            }

            switch (snapshot.data) {
              case CreateSessionState.CREATED:
                return _getBody(bloc.sid);
              default:
                return loadingIndicator();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Widget _getBody(String sid) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(
          FlutterI18n.translate(context, "create.sid"),
          style: Theme.of(context).textTheme.body1,
        ),
        new Padding(
          padding: const EdgeInsets.only(bottom: 10),
        ),
        new Text(
          sid,
          style: Theme.of(context).textTheme.subhead,
        ),
        new Padding(
          padding: const EdgeInsets.only(bottom: 40),
        ),
        _getContinueButton(),
      ],
    );
  }

  Widget _getContinueButton() {
    return new CustomButton.withTheme(
      onPressed: _pushMainScreen,
      theme: Theme.of(context),
      child: new Text(
        FlutterI18n.translate(context, "create.continue"),
      ),
      radius: 20,
      constraints: new BoxConstraints.tight(new Size(160, 40)),
    );
  }

  void _pushMainScreen() {
    Navigator.of(context).pushReplacementNamed("/main");
  }
}
