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
  State<StatefulWidget> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  CreateBloc bloc;
  StreamSubscription subscription;

  @override
  void initState() {
    // Get a reference to the create bloc for this context.
    bloc = BlocProvider.of<CreateBloc>(context);

    // Create a subscription to the bloc's state stream.
    subscription = bloc.stream.listen(
      (CreateSessionState state) {
        switch (state) {
          case CreateSessionState.NOT_CREATED:
            // If we are in the "zero state", tell the bloc to create a session.
            bloc.sink.add(CreateSessionState.CREATING);
            break;
          default:
            break;
        }
      },
      onError: (e) {
        // If the error was produced by the bloc, retrieve the error message.
        String message = e is StateError ? e.message : "errors.unknown";

        // Show the user an error message.
        showFailedAlert(
          context,
          FlutterI18n.translate(context, message),
          // Return to the choose screen when the user acknowledges the error.
          _pushChooseScreen,
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Container(
        child: Center(
          child: StreamBuilder(
            stream: bloc.stream,
            builder: (
              BuildContext context,
              AsyncSnapshot<CreateSessionState> snapshot,
            ) {
              // If there is no stream data or there is an error, show a
              // loading indicator.
              if (snapshot == null || !snapshot.hasData || snapshot.hasError) {
                return loadingIndicator();
              }

              switch (snapshot.data) {
                case CreateSessionState.CREATED:
                  // If the session has been created, show the user their
                  // session ID.
                  return _getBody();
                default:
                  // If the session is being created, show a loading indicator.
                  return loadingIndicator();
              }
            },
          ),
        ),
      ),
      onWillPop: () => Future.value(false),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Widget _getBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          FlutterI18n.translate(context, "create.sid"),
          style: Theme.of(context).textTheme.body1,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
        ),
        Text(
          bloc.sid,
          style: Theme.of(context).textTheme.subhead,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 40),
        ),
        _getContinueButton(),
      ],
    );
  }

  Widget _getContinueButton() {
    return CustomButton.withTheme(
      onPressed: _pushMainScreen,
      theme: Theme.of(context),
      child: Text(
        FlutterI18n.translate(context, "create.continue"),
      ),
      radius: 20,
      constraints: BoxConstraints.tight(Size(160, 40)),
    );
  }

  void _pushChooseScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      "/choose",
      (Route<dynamic> route) => false,
    );
  }

  void _pushMainScreen() {
    Navigator.of(context).pushReplacementNamed("/main");
  }
}
