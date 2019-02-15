import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/blocs/firebase_connect_bloc.dart';
import 'package:yes_music/components/common/text_button.dart';
import 'package:yes_music/data/firebase/auth_handler_base.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseConnectBloc connectBloc =
        BlocProvider.of<FirebaseConnectBloc>(context);
    final Color overlay = Theme.of(context).primaryColor.withAlpha(200);

    return new Container(
      decoration: _getBackground(overlay),
      child: new Center(
        child: new StreamBuilder(
          stream: connectBloc.authSubject.stream,
          builder: (
            BuildContext context,
            AsyncSnapshot<FirebaseAuthState> snapshot,
          ) {
            if (snapshot == null || !snapshot.hasData) {
              return _loadingIndicator();
            }

            switch (snapshot.data) {
              case FirebaseAuthState.UNAUTHORIZED:
                connectBloc.signInSilently();
                return _loadingIndicator();
              case FirebaseAuthState.AUTHORIZING_SILENTLY:
                return _loadingIndicator();
              case FirebaseAuthState.UNAUTHORIZED_SILENTLY:
                return _getConnectButtons(context, connectBloc);
              case FirebaseAuthState.AUTHORIZING:
                return _loadingIndicator();
              case FirebaseAuthState.AUTHORIZED:
                return new Text("authorized");
              case FirebaseAuthState.FAILED:
                return new Text("failed");
              case FirebaseAuthState.AWAITING_PHONE_CODE:
                return new Text("awaiting phone number");
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

  Widget _getConnectButtons(BuildContext context, FirebaseConnectBloc bloc) {
    return new Container(
      constraints: new BoxConstraints.tight(new Size(160, 200)),
      child: new Column(
        children: <Widget>[
          new Text(
            FlutterI18n.translate(context, "login.connect.connectPrompt"),
            style: Theme.of(context).textTheme.headline,
          ),
          new Container(
            padding: new EdgeInsets.only(bottom: 20),
          ),
          new TextButton.withTheme(
            onPressed: () => bloc.signInWithGoogle(),
            theme: Theme.of(context),
            child: new Text(
              FlutterI18n.translate(context, "login.connect.connectGoogle"),
            ),
            radius: 20,
            constraints: new BoxConstraints.tight(new Size(160, 40)),
          ),
          new Container(
            padding: new EdgeInsets.only(bottom: 10),
          ),
          new TextButton.withTheme(
            onPressed: () => {},
            theme: Theme.of(context),
            child: new Text(
              FlutterI18n.translate(
                  context, "login.connect.connectPhoneNumber"),
            ),
            radius: 20,
            constraints: new BoxConstraints.tight(new Size(160, 40)),
            textStyle: Theme.of(context).textTheme.button,
          ),
        ],
      ),
    );
  }
}
