import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yes_music/blocs/session_state_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/loading_indicator.dart';
import 'package:yes_music/components/common/bar_actions.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SessionStateBloc _sessionBloc;
  StreamSubscription<SessionState> _stateSubscription;

  @override
  void initState() {
    _sessionBloc = BlocProvider.of<SessionStateBloc>(context);

    _stateSubscription = _sessionBloc.stream.listen((SessionState state) {
      switch (state) {
        case SessionState.INACTIVE:
          _pushLoginScreen();
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
        stream: _sessionBloc.stream,
        builder: (
          BuildContext context,
          AsyncSnapshot<SessionState> snapshot,
        ) {
          if (snapshot == null || !snapshot.hasData || snapshot.hasError) {
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
    super.dispose();
  }

  Widget _getContent() {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Builder(
        builder: (BuildContext context) => CustomScrollView(
              slivers: <Widget>[
                _getAppBar(width, Uint8List(0), context),
                _getQueue(),
              ],
            ),
      ),
      floatingActionButton: _getAddButton(),
    );
  }

  SliverAppBar _getAppBar(double width, Uint8List bytes, BuildContext context) {
    return SliverAppBar(
      actions: getAppBarActions(
        context,
        [
          BarActions.SID,
          BarActions.LEAVE,
        ],
      ),
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
