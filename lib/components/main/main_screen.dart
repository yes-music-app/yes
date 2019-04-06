import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/login_bloc.dart';
import 'package:yes_music/blocs/session_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/confirmation_dialog.dart';
import 'package:yes_music/components/common/loading_indicator.dart';

enum BarActions {
  LOGOUT,
}

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SessionBloc _sessionBloc;
  LoginBloc _loginBloc;
  StreamSubscription<SessionState> _stateSubscription;
  StreamSubscription<FirebaseAuthState> _loginSubscription;
  bool _signingOut = false;

  @override
  void initState() {
    _sessionBloc = BlocProvider.of<SessionBloc>(context);
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    _stateSubscription =
        _sessionBloc.sessionStream.listen((SessionState state) {
      switch (state) {
        case SessionState.LEFT:
          _pushLoginScreen();
          break;
        default:
          break;
      }
    });

    _loginSubscription = _loginBloc.stream.listen((FirebaseAuthState state) {
      switch (state) {
        case FirebaseAuthState.UNAUTHORIZED:
          _sessionBloc.sessionSink.add(SessionState.LEAVING);
          break;
        default:
          break;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: StreamBuilder(
        stream: _sessionBloc.sessionStream,
        builder: (
          BuildContext context,
          AsyncSnapshot<SessionState> snapshot,
        ) {
          if (snapshot == null ||
              !snapshot.hasData ||
              snapshot.hasError ||
              _signingOut) {
            return loadingIndicator();
          }

          switch (snapshot.data) {
            case SessionState.ACTIVE:
              return _getContent();
            default:
              return loadingIndicator();
          }
        },
      ),
      onWillPop: () => Future.value(false),
    );
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _loginSubscription?.cancel();
    super.dispose();
  }

  Widget _getContent() {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _getAppBar(width, Uint8List(0)),
          _getQueue(),
        ],
      ),
      floatingActionButton: _getAddButton(),
    );
  }

  SliverAppBar _getAppBar(double width, Uint8List bytes) {
    return SliverAppBar(
      actions: _getAppBarActions(),
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 10,
      expandedHeight: width * (2 / 3),
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: _getAppBarImage(bytes),
      ),
      title: Text("Now playing"),
    );
  }

  List<Widget> _getAppBarActions() {
    return [
      PopupMenuButton<BarActions>(
        onSelected: (BarActions result) {
          switch (result) {
            case BarActions.LOGOUT:
              _logout();
              break;
            default:
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<BarActions>>[
              PopupMenuItem<BarActions>(
                value: BarActions.LOGOUT,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Text(FlutterI18n.translate(context, "main.logout")),
                  ],
                ),
              ),
            ],
      ),
    ];
  }

  void _logout() {
    showConfirmationDialog(
      context,
      "main.logoutMessage",
      "confirm",
      "cancel",
      () {
        _loginBloc.sink.add(FirebaseAuthState.SIGNING_OUT);
        setState(() {
          _signingOut = true;
        });
      },
      () {},
    );
  }

  Widget _getAppBarImage(Uint8List bytes) {
    return bytes == null || bytes.isEmpty
        ? Center(
            child: loadingIndicator(),
          )
        : FittedBox(
            fit: BoxFit.fitWidth,
            child: Image.memory(bytes),
          );
  }

  SliverList _getQueue() {
    return SliverList(
      delegate: _queueDelegate(),
    );
  }

  SliverChildBuilderDelegate _queueDelegate() {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Text("hello world"),
        );
      },
      childCount: 50,
    );
  }

  Widget _getAddButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => {},
    );
  }

  void _pushLoginScreen() {
    Navigator.of(context).pushReplacementNamed("/");
  }
}
