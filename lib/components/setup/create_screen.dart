import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/session_state_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/custom_button.dart';
import 'package:yes_music/components/common/failed_alert.dart';
import 'package:yes_music/components/common/loading_indicator.dart';
import 'package:yes_music/components/setup/spotify_webview.dart';

/// The screen that allows a user to create a new session.
class CreateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  SessionStateBloc _stateBloc;
  StreamSubscription _stateSub;

  @override
  void initState() {
    // Get a reference to the create bloc for this context.
    _stateBloc = BlocProvider.of<SessionStateBloc>(context);

    // Create a subscription to the bloc's state stream.
    _stateSub = _stateBloc.stateStream.listen(
      (SessionState state) {},
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

    // Launch the WebView when a url is received.
    _stateBloc.urlStream.first.then((String url) {
      _stateBloc.stateSink.add(SessionState.AWAITING_TOKENS);
      showAuthWebView(
        url,
        onSuccess: _onConnectSuccess,
        onFail: _onConnectFail,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Container(
        child: StreamBuilder(
          stream: _stateBloc.stateStream,
          builder: (
            BuildContext context,
            AsyncSnapshot<SessionState> snapshot,
          ) {
            // If there is no stream data or there is an error, show a
            // loading indicator.
            if (snapshot == null || !snapshot.hasData || snapshot.hasError) {
              return loadingIndicator();
            }

            switch (snapshot.data) {
              case SessionState.CREATED:
                return _getBody();
              default:
                return loadingIndicator();
            }
          },
        ),
      ),
      onWillPop: () => Future.value(false),
    );
  }

  @override
  void dispose() {
    _stateSub.cancel();
    super.dispose();
  }

  Widget _getBody() {
    return Center(
      child: Column(
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
            _stateBloc.sid(checked: true),
            style: Theme.of(context).textTheme.subhead,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
          ),
          _getContinueButton(),
        ],
      ),
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

  /// The action to perform when the user connects with Spotify.
  void _onConnectSuccess(String code) {
    _stateBloc.stateSink.add(SessionState.CREATING);
    _stateBloc.codeSink.add(code);
  }

  /// The action to perform when the user fails to connect with Spotify.
  void _onConnectFail() {
    _stateBloc.stateSink.addError(StateError("errors.spotify.auth_cancel"));
  }

  void _pushChooseScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      "/choose",
      (Route<dynamic> route) => false,
    );
  }

  void _pushMainScreen() {
    _stateBloc.stateSink.add(SessionState.ACTIVE);
    Navigator.of(context).pushReplacementNamed("/main");
  }
}
