import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/blocs/firebase_connect_bloc.dart';
import 'package:yes_music/data/firebase/auth_handler_base.dart';

Widget phoneNumberDialog(BuildContext context) {
  FirebaseConnectBloc bloc = BlocProvider.of<FirebaseConnectBloc>(context);
  TextEditingController numberController = new TextEditingController();
  TextEditingController codeController = new TextEditingController();

  return new StreamBuilder(
    stream: bloc.stream,
    builder: (
      BuildContext context,
      AsyncSnapshot<FirebaseAuthState> snapshot,
    ) {
      if (snapshot == null || !snapshot.hasData) {
        return new AlertDialog(
          content: _loadingIndicator(),
        );
      }

      Widget content;
      List<Widget> actions;

      switch (snapshot.data) {
        case FirebaseAuthState.AWAITING_PHONE_NUMBER:
          content = _numberContents(context, bloc, numberController);
          actions = _numberActions(context, bloc, numberController);
          break;
        case FirebaseAuthState.AWAITING_PHONE_CODE:
          content = _codeContents(context, bloc, codeController);
          actions = _codeActions(context, bloc, codeController);
          break;
        default:
          content = _loadingIndicator();
          actions = [];
          break;
      }

      return new AlertDialog(
        content: content,
        actions: actions,
      );
    },
  );
}

Widget _loadingIndicator() {
  return new Center(
    child: new CircularProgressIndicator(),
  );
}

Widget _numberContents(
  BuildContext context,
  FirebaseConnectBloc bloc,
  TextEditingController numberController,
) {
  return new SingleChildScrollView(
    child: new ListBody(
      children: <Widget>[
        new Text(
          FlutterI18n.translate(context, "login.phoneNumber.numberPrompt"),
          style: Theme.of(context).textTheme.body1,
        ),
        new TextField(
          autocorrect: false,
          controller: numberController,
          keyboardType: TextInputType.number,
          onSubmitted: (String number) {
            bloc.signInWithPhone(number);
          },
        ),
        new Text(
          FlutterI18n.translate(context, "login.phoneNumber.numberDisclaimer"),
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    ),
  );
}

Widget _codeContents(
  BuildContext context,
  FirebaseConnectBloc bloc,
  TextEditingController codeController,
) {
  return new SingleChildScrollView(
    child: new ListBody(
      children: <Widget>[
        new Text(
          FlutterI18n.translate(context, "login.phoneNumber.codePrompt"),
          style: Theme.of(context).textTheme.body1,
        ),
        new TextField(
          autocorrect: false,
          controller: codeController,
          keyboardType: TextInputType.number,
          onSubmitted: (String code) {
            bloc.checkCode(code);
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

List<Widget> _numberActions(
  BuildContext context,
  FirebaseConnectBloc bloc,
  TextEditingController numberController,
) {
  return <Widget>[
    new FlatButton(
      onPressed: () {
        bloc.sink.add(FirebaseAuthState.UNAUTHORIZED_SILENTLY);
        Navigator.of(context).pop();
      },
      child: new Text(
        FlutterI18n.translate(context, "cancel"),
        style: Theme.of(context).textTheme.button,
      ),
    ),
    new FlatButton(
      onPressed: () {
        bloc.signInWithPhone(numberController.value.text);
      },
      child: new Text(
        FlutterI18n.translate(context, "submit"),
        style: Theme.of(context).textTheme.button,
      ),
    ),
  ];
}

List<Widget> _codeActions(
  BuildContext context,
  FirebaseConnectBloc bloc,
  TextEditingController codeController,
) {
  return <Widget>[
    new FlatButton(
      onPressed: () {
        bloc.sink.add(FirebaseAuthState.UNAUTHORIZED_SILENTLY);
        Navigator.of(context).pop();
      },
      child: new Text(
        FlutterI18n.translate(context, "cancel"),
        style: Theme.of(context).textTheme.button,
      ),
    ),
    new FlatButton(
      onPressed: () {
        bloc.checkCode(codeController.value.text);
        Navigator.of(context).pop();
      },
      child: new Text(
        FlutterI18n.translate(context, "submit"),
        style: Theme.of(context).textTheme.button,
      ),
    ),
  ];
}