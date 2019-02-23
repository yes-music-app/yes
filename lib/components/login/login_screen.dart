import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/blocs/firebase_connect_bloc.dart';
import 'package:yes_music/components/common/custom_button.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseConnectBloc bloc =
        BlocProvider.of<FirebaseConnectBloc>(context);
    final Color overlay = Theme.of(context).primaryColor.withAlpha(200);

    bloc.stream.listen((FirebaseAuthState state) {
      switch (state) {
        case FirebaseAuthState.UNAUTHORIZED:
          bloc.sink.add(FirebaseAuthState.AUTHORIZING_SILENTLY);
          break;
        case FirebaseAuthState.FAILED:
          _showFailedDialog(context, bloc);
          return _loadingIndicator();
        case FirebaseAuthState.AUTHORIZED:
          _pushChooseScreen(context);
          break;
        default:
          break;
      }
    });

    return new Container(
      decoration: _getBackground(overlay),
      child: new Center(
        child: new StreamBuilder(
          stream: bloc.stream,
          builder: (
            BuildContext context,
            AsyncSnapshot<FirebaseAuthState> snapshot,
          ) {
            if (snapshot == null || !snapshot.hasData) {
              return _loadingIndicator();
            }

            switch (snapshot.data) {
              case FirebaseAuthState.UNAUTHORIZED_SILENTLY:
                return _getConnectButton(context, bloc);
              default:
                return _loadingIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _loadingIndicator() {
    return new CircularProgressIndicator();
  }

  BoxDecoration _getBackground(Color overlay) {
    return new BoxDecoration(
      image: new DecorationImage(
        fit: BoxFit.fitHeight,
        colorFilter: new ColorFilter.mode(overlay, BlendMode.multiply),
        image: new AssetImage("assets/login/background.png"),
      ),
    );
  }

  Widget _getConnectButton(BuildContext context, FirebaseConnectBloc bloc) {
    List<Widget> widgets = <Widget>[
      new Text(
        FlutterI18n.translate(context, "login.connectPrompt"),
        style: Theme.of(context).textTheme.headline,
      ),
      new Padding(
        padding: new EdgeInsets.only(bottom: 20),
      ),
      new CustomButton.withTheme(
        onPressed: () => bloc.sink.add(FirebaseAuthState.AUTHORIZING),
        theme: Theme.of(context),
        child: new Text(
          FlutterI18n.translate(context, "login.connectGoogle"),
        ),
        radius: 20,
        constraints: new BoxConstraints.tight(new Size(160, 40)),
      ),
    ];

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgets,
    );
  }

  void _showFailedDialog(BuildContext context, FirebaseConnectBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) => _failedAlert(context, bloc),
    );
  }

  Widget _failedAlert(BuildContext context, FirebaseConnectBloc bloc) {
    return new AlertDialog(
      content: new SingleChildScrollView(
        child: new Text(
          FlutterI18n.translate(context, "login.failedInfo"),
          style: Theme.of(context).textTheme.body1,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: new Text(
            FlutterI18n.translate(context, "ok"),
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () {
            bloc.sink.add(FirebaseAuthState.UNAUTHORIZED_SILENTLY);
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  void _pushChooseScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed("/choose");
  }
}
