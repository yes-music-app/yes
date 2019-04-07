import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/login_bloc.dart';
import 'package:yes_music/blocs/session_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/confirmation_dialog.dart';

enum BarActions {
  LEAVE,
  LOGOUT,
}

List<Widget> getAppBarActions(
  BuildContext context,
  List<BarActions> actions,
) {
  // Generate a list of the action items that should be added to the bar.
  List<PopupMenuItem<BarActions>> items = [];
  actions.forEach((BarActions action) {
    switch (action) {
      case BarActions.LEAVE:
        items.add(_getLeaveItem(context));
        break;
      case BarActions.LOGOUT:
        items.add(_getLogoutItem(context));
        break;
      default:
        break;
    }
  });

  return [
    PopupMenuButton<BarActions>(
      onSelected: (BarActions result) {
        switch (result) {
          case BarActions.LEAVE:
            _leave(context);
            break;
          case BarActions.LOGOUT:
            _logout(context);
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) => items,
    ),
  ];
}

/// Gets the menu item for the leave action.
PopupMenuItem<BarActions> _getLeaveItem(BuildContext context) {
  return PopupMenuItem<BarActions>(
    value: BarActions.LEAVE,
    child: Row(
      children: <Widget>[
        Icon(Icons.exit_to_app),
        Padding(padding: EdgeInsets.only(left: 10)),
        Text(FlutterI18n.translate(context, "main.leave")),
      ],
    ),
  );
}

/// Initiate the action of the user leaving a session.
void _leave(BuildContext context) {
  showConfirmationDialog(
    context,
    "main.leaveMessage",
    "confirm",
    "cancel",
    () {
      BlocProvider.of<SessionBloc>(context)
          .sessionSink
          .add(SessionState.LEAVING);
    },
    () {},
  );
}

/// Gets the menu item for the logout action.
PopupMenuItem<BarActions> _getLogoutItem(BuildContext context) {
  return PopupMenuItem<BarActions>(
    value: BarActions.LOGOUT,
    child: Row(
      children: <Widget>[
        Icon(Icons.face),
        Padding(padding: EdgeInsets.only(left: 10)),
        Text(FlutterI18n.translate(context, "main.logout")),
      ],
    ),
  );
}

/// Initiate the action of the user logging out of their Google account.
void _logout(BuildContext context) {
  showConfirmationDialog(
    context,
    "main.logoutMessage",
    "confirm",
    "cancel",
    () {
      BlocProvider.of<LoginBloc>(context)
          .sink
          .add(FirebaseAuthState.SIGNING_OUT);
    },
    () {},
  );
}