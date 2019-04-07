import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/login_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/bar_actions.dart';
import 'package:yes_music/components/common/custom_button.dart';
import 'package:yes_music/components/common/loading_indicator.dart';

class ChooseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  LoginBloc _bloc;
  StreamSubscription _subscription;

  @override
  void initState() {
    _bloc = BlocProvider.of<LoginBloc>(context);
    _subscription = _bloc.stream.listen(
      (FirebaseAuthState state) {
        switch (state) {
          case FirebaseAuthState.UNAUTHORIZED:
            _pushLoginScreen();
            break;
          default:
            break;
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        actions: getAppBarActions(
          context,
          [BarActions.LOGOUT],
        ),
      ),
      body: StreamBuilder(
        stream: _bloc.stream,
        builder: (
          BuildContext context,
          AsyncSnapshot<FirebaseAuthState> snapshot,
        ) {
          if (snapshot == null || !snapshot.hasData) {
            return loadingIndicator();
          }

          switch (snapshot.data) {
            case FirebaseAuthState.AUTHORIZED:
              return _getButtons();
            default:
              return loadingIndicator();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Widget _getButtons() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomButton.withTheme(
            onPressed: () {
              Navigator.of(context).pushNamed("/appRemote");
            },
            theme: Theme.of(context),
            child: Text(
              FlutterI18n.translate(context, "choose.create"),
            ),
            radius: 20,
            constraints: BoxConstraints.tight(Size(160, 40)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
          ),
          CustomButton.withTheme(
            onPressed: () {
              Navigator.of(context).pushNamed("/join");
            },
            theme: Theme.of(context),
            child: Text(
              FlutterI18n.translate(context, "choose.join"),
            ),
            radius: 20,
            constraints: BoxConstraints.tight(Size(160, 40)),
          ),
        ],
      ),
    );
  }

  void _pushLoginScreen() {
    Navigator.of(context).pushReplacementNamed("/");
  }
}
