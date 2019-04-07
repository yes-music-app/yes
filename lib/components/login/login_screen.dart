import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/login_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/custom_button.dart';
import 'package:yes_music/components/common/failed_alert.dart';
import 'package:yes_music/components/common/loading_indicator.dart';

/// The screen that handles a user's attempt to log in to Firebase.
class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _bloc;
  StreamSubscription _subscription;

  @override
  void initState() {
    _bloc = BlocProvider.of<LoginBloc>(context);
    _subscription = _bloc.stream.listen(
      (FirebaseAuthState state) {
        switch (state) {
          case FirebaseAuthState.UNAUTHORIZED:
            _bloc.sink.add(FirebaseAuthState.AUTHORIZING_SILENTLY);
            break;
          case FirebaseAuthState.AUTHORIZED:
            _pushChooseScreen(context);
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
          () => _bloc.sink.add(FirebaseAuthState.UNAUTHORIZED_SILENTLY),
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color overlay = Theme.of(context).primaryColor.withAlpha(200);

    return Container(
      decoration: _getBackground(overlay),
      child: Center(
        child: StreamBuilder(
          stream: _bloc.stream,
          builder: (
            BuildContext context,
            AsyncSnapshot<FirebaseAuthState> snapshot,
          ) {
            if (snapshot == null || !snapshot.hasData || snapshot.hasError) {
              return loadingIndicator();
            }

            switch (snapshot.data) {
              case FirebaseAuthState.UNAUTHORIZED_SILENTLY:
                return _getConnectButton();
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
    _subscription?.cancel();
    super.dispose();
  }

  BoxDecoration _getBackground(Color overlay) {
    return BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.fitHeight,
        colorFilter: ColorFilter.mode(overlay, BlendMode.multiply),
        image: AssetImage("assets/login/background.png"),
      ),
    );
  }

  Widget _getConnectButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          FlutterI18n.translate(context, "login.connectPrompt"),
          style: Theme.of(context).textTheme.headline,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
        CustomButton.withTheme(
          onPressed: () => _bloc.sink.add(FirebaseAuthState.AUTHORIZING),
          theme: Theme.of(context),
          child: Text(
            FlutterI18n.translate(context, "login.connectGoogle"),
            style: Theme.of(context).textTheme.button,
          ),
          radius: 20,
          constraints: BoxConstraints.tight(Size(160, 40)),
        ),
      ],
    );
  }

  void _pushChooseScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed("/choose");
  }
}
