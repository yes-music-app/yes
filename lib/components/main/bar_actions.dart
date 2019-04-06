import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/login_bloc.dart';
import 'package:yes_music/blocs/session_bloc.dart';
import 'package:yes_music/components/common/confirmation_dialog.dart';

enum BarActions {
  LEAVE,
  LOGOUT,
}

List<Widget> getAppBarActions(
  BuildContext context, {
  @required SessionBloc sessionBloc,
  @required LoginBloc loginBloc,
}) {
  return [
    PopupMenuButton<BarActions>(
      onSelected: (BarActions result) {
        switch (result) {
          case BarActions.LEAVE:
            _leave(context, sessionBloc);
            break;
          case BarActions.LOGOUT:
            _logout(context, loginBloc);
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<BarActions>>[
            PopupMenuItem<BarActions>(
              value: BarActions.LEAVE,
              child: Row(
                children: <Widget>[
                  Icon(Icons.exit_to_app),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Text(FlutterI18n.translate(context, "main.leave")),
                ],
              ),
            ),
            PopupMenuItem<BarActions>(
              value: BarActions.LOGOUT,
              child: Row(
                children: <Widget>[
                  Icon(Icons.face),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Text(FlutterI18n.translate(context, "main.logout")),
                ],
              ),
            ),
          ],
    ),
  ];
}

/// Initiate the action of the user leaving a session.
void _leave(BuildContext context, SessionBloc sessionBloc) {
  showConfirmationDialog(
    context,
    "main.leaveMessage",
    "confirm",
    "cancel",
    () {
      sessionBloc.sessionSink.add(SessionState.LEAVING);
    },
    () {},
  );
}

/// Initiate the action of the user logging out of their Google account.
void _logout(BuildContext context, LoginBloc loginBloc) {
  showConfirmationDialog(
    context,
    "main.logoutMessage",
    "confirm",
    "cancel",
    () {
      loginBloc.sink.add(FirebaseAuthState.SIGNING_OUT);
    },
    () {},
  );
}
