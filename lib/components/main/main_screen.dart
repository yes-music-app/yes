import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/session_data_bloc.dart';
import 'package:yes_music/blocs/session_state_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/bar_actions.dart';
import 'package:yes_music/components/common/loading_indicator.dart';
import 'package:yes_music/components/common/track_card.dart';
import 'package:yes_music/models/state/song_model.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SessionStateBloc _stateBloc;
  SessionDataBloc _dataBloc;
  StreamSubscription<SessionState> _stateSubscription;

  /// A key to keep track of the scaffold.
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    // Get bloc references.
    _stateBloc = BlocProvider.of<SessionStateBloc>(context);
    _dataBloc = BlocProvider.of<SessionDataBloc>(context);

    _stateSubscription = _stateBloc.stateStream.listen((SessionState state) {
      switch (state) {
        case SessionState.INACTIVE:
          _pushChooseScreen();
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
        stream: _stateBloc.stateStream,
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

  /// Gets the main widgets to display.
  Widget _getContent() {
    return StreamBuilder(
      stream: _dataBloc.tokenStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot == null ||
            !snapshot.hasData ||
            snapshot.hasError ||
            snapshot.data.isEmpty) {
          return loadingIndicator();
        }

        return Scaffold(
          key: _scaffoldKey,
          body: _getBody(),
          floatingActionButton: _getAddButton(),
        );
      },
    );
  }

  /// Gets the actual contents of the
  Widget _getBody() {
    double width = MediaQuery.of(context).size.width;
    return CustomScrollView(
      slivers: <Widget>[
        _getAppBar(width, Uint8List(0)),
        _getQueue(),
        SliverPadding(padding: EdgeInsets.only(top: 5)),
      ],
    );
  }

  SliverAppBar _getAppBar(double width, Uint8List bytes) {
    return SliverAppBar(
      actions: getAppBarActions(
        context,
        [BarActions.SID, BarActions.LEAVE],
        scaffoldKey: _scaffoldKey,
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
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Image.network(
          "https://i.scdn.co/image/44eeb521fbba3523d65bb0e2b9b2893965fcd437"),
    );
  }

  /// The queue of songs that are coming up.
  Widget _getQueue() {
    const double CARD_HEIGHT = 60;

    return StreamBuilder(
      stream: _dataBloc.queueListStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<SongModel>> snapshot,
      ) {
        if (snapshot == null || !snapshot.hasData || snapshot.hasError) {
          return _getLoadingStatus();
        }

        // Get a reference to the queued tracks.
        List<SongModel> tracks = snapshot.data;

        if (tracks.isEmpty) {
          // If there are no tracks, indicate that to the user.
          return _getEmptyQueueStatus();
        }

        return SliverFixedExtentList(
          itemExtent: CARD_HEIGHT,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) =>
                trackCard(tracks[index].track, context),
            childCount: tracks.length,
          ),
        );
      },
    );
  }

  /// Gets a loading status indicator.
  Widget _getLoadingStatus() {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 30),
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  /// Gets a status message telling the user that the queue is empty.
  Widget _getEmptyQueueStatus() {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 30),
            child: Text(
              FlutterI18n.translate(context, "main.queueEmpty"),
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    );
  }

  /// The button that launches the search screen.
  Widget _getAddButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: _pushSearchScreen,
    );
  }

  /// Push the choose screen as the base route.
  void _pushChooseScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      "/choose",
      (Route<dynamic> route) => false,
    );
  }

  /// Push the search screen with the access token as an argument.
  void _pushSearchScreen() {
    Navigator.of(context).pushNamed(
      "/search",
      arguments: _dataBloc,
    );
  }
}
