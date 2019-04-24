import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yes_music/blocs/session_state_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/bar_actions.dart';
import 'package:yes_music/components/common/loading_indicator.dart';
import 'package:yes_music/components/common/track_card.dart';
import 'package:yes_music/models/spotify/track_model.dart';

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

    _stateSubscription = _sessionBloc.stateStream.listen((SessionState state) {
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
        stream: _sessionBloc.stateStream,
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
                SliverPadding(padding: EdgeInsets.only(top: 5)),
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
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Image.network(
          "https://i.scdn.co/image/44eeb521fbba3523d65bb0e2b9b2893965fcd437"),
    );
    /*bytes == null || bytes.isEmpty
        ? Center(
            child: loadingIndicator(),
          )
        : FittedBox(
            fit: BoxFit.fitWidth,
            child: Image.memory(bytes),
          );*/
  }

  SliverList _getQueue() {
    return SliverList(
      delegate: _queueDelegate(),
    );
  }

  SliverChildBuilderDelegate _queueDelegate() {
    final Map tempTrack = {
      "album": {
        "album_type": "album",
        "artists": [
          {
            "external_urls": {
              "spotify":
                  "https://open.spotify.com/artist/2RhgnQNC74QoBlaUvT4MEe"
            },
            "href": "https://api.spotify.com/v1/artists/2RhgnQNC74QoBlaUvT4MEe",
            "id": "2RhgnQNC74QoBlaUvT4MEe",
            "name": "The Growlers",
            "type": "artist",
            "uri": "spotify:artist:2RhgnQNC74QoBlaUvT4MEe"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/0b7iiX6rAdsggW5ERuLWB7"
        },
        "href": "https://api.spotify.com/v1/albums/0b7iiX6rAdsggW5ERuLWB7",
        "id": "0b7iiX6rAdsggW5ERuLWB7",
        "images": [
          {
            "height": 640,
            "url":
                "https://i.scdn.co/image/12f844b98fd8bc20ad16d2c83fdcfb7751787ea8",
            "width": 640
          },
          {
            "height": 300,
            "url":
                "https://i.scdn.co/image/c6c758d870f7acbbea075ddf55d547b5ff7a1935",
            "width": 300
          },
          {
            "height": 64,
            "url":
                "https://i.scdn.co/image/053d452277c79d269352cd7bbdb860814da10784",
            "width": 64
          }
        ],
        "name": "Chinese Fountain",
        "release_date": "2014-09-23",
        "release_date_precision": "day",
        "total_tracks": 11,
        "type": "album",
        "uri": "spotify:album:0b7iiX6rAdsggW5ERuLWB7"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/2RhgnQNC74QoBlaUvT4MEe"
          },
          "href": "https://api.spotify.com/v1/artists/2RhgnQNC74QoBlaUvT4MEe",
          "id": "2RhgnQNC74QoBlaUvT4MEe",
          "name": "The Growlers",
          "type": "artist",
          "uri": "spotify:artist:2RhgnQNC74QoBlaUvT4MEe"
        }
      ],
      "disc_number": 1,
      "duration_ms": 249266,
      "explicit": false,
      "external_ids": {"isrc": "USER81404408"},
      "external_urls": {
        "spotify": "https://open.spotify.com/track/71bWpBImqNaLjIvfV50Hsa"
      },
      "href": "https://api.spotify.com/v1/tracks/71bWpBImqNaLjIvfV50Hsa",
      "id": "71bWpBImqNaLjIvfV50Hsa",
      "is_local": false,
      "name": "Love Test",
      "popularity": 52,
      "preview_url":
          "https://p.scdn.co/mp3-preview/48c64aa7fea8f151158acfabd64a5ebc06aac47b?cid=a50706c333cb40a396c6020d9c79fb8b",
      "track_number": 8,
      "type": "track",
      "uri": "spotify:track:71bWpBImqNaLjIvfV50Hsa"
    };
    TrackModel model = TrackModel.fromMap(tempTrack);

    return SliverChildBuilderDelegate(
      (BuildContext context, int index) => trackCard(model, context),
      childCount: 20,
    );
  }

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
      // TODO: Change this to the access token for this session.
      arguments: "",
    );
  }
}
