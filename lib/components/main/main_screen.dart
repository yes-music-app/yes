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
                  "https://open.spotify.com/artist/3tJoFztHeIJkJWMrx0td2f"
            },
            "href": "https://api.spotify.com/v1/artists/3tJoFztHeIJkJWMrx0td2f",
            "id": "3tJoFztHeIJkJWMrx0td2f",
            "name": "Moneybagg Yo",
            "type": "artist",
            "uri": "spotify:artist:3tJoFztHeIJkJWMrx0td2f"
          },
          {
            "external_urls": {
              "spotify":
                  "https://open.spotify.com/artist/7wlFDEWiM5OoIAt8RSli8b"
            },
            "href": "https://api.spotify.com/v1/artists/7wlFDEWiM5OoIAt8RSli8b",
            "id": "7wlFDEWiM5OoIAt8RSli8b",
            "name": "YoungBoy Never Broke Again",
            "type": "artist",
            "uri": "spotify:artist:7wlFDEWiM5OoIAt8RSli8b"
          }
        ],
        "available_markets": [
          "AD",
          "AE",
          "AR",
          "AT",
          "AU",
          "BE",
          "BG",
          "BH",
          "BO",
          "BR",
          "CA",
          "CH",
          "CL",
          "CO",
          "CR",
          "CY",
          "CZ",
          "DE",
          "DK",
          "DO",
          "DZ",
          "EC",
          "EE",
          "EG",
          "ES",
          "FI",
          "FR",
          "GB",
          "GR",
          "GT",
          "HK",
          "HN",
          "HU",
          "ID",
          "IE",
          "IL",
          "IN",
          "IS",
          "IT",
          "JO",
          "JP",
          "KW",
          "LB",
          "LI",
          "LT",
          "LU",
          "LV",
          "MA",
          "MC",
          "MT",
          "MX",
          "MY",
          "NI",
          "NL",
          "NO",
          "NZ",
          "OM",
          "PA",
          "PE",
          "PH",
          "PL",
          "PS",
          "PT",
          "PY",
          "QA",
          "RO",
          "SA",
          "SE",
          "SG",
          "SK",
          "SV",
          "TH",
          "TN",
          "TR",
          "TW",
          "US",
          "UY",
          "VN",
          "ZA"
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/4RUq0kdGLKc5ROEv8I0lRY"
        },
        "href": "https://api.spotify.com/v1/albums/4RUq0kdGLKc5ROEv8I0lRY",
        "id": "4RUq0kdGLKc5ROEv8I0lRY",
        "images": [
          {
            "height": 640,
            "url":
                "https://i.scdn.co/image/44eeb521fbba3523d65bb0e2b9b2893965fcd437",
            "width": 640
          },
          {
            "height": 300,
            "url":
                "https://i.scdn.co/image/af8a6955600797b2d65dc8a05951c240698c3ec5",
            "width": 300
          },
          {
            "height": 64,
            "url":
                "https://i.scdn.co/image/5718ffbc6e63b4dd95c2165d5d12671dbe6d0ce4",
            "width": 64
          }
        ],
        "name": "Fed Baby’s",
        "release_date": "2017-11-17",
        "release_date_precision": "day",
        "total_tracks": 14,
        "type": "album",
        "uri": "spotify:album:4RUq0kdGLKc5ROEv8I0lRY"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/3tJoFztHeIJkJWMrx0td2f"
          },
          "href": "https://api.spotify.com/v1/artists/3tJoFztHeIJkJWMrx0td2f",
          "id": "3tJoFztHeIJkJWMrx0td2f",
          "name": "Moneybagg Yo",
          "type": "artist",
          "uri": "spotify:artist:3tJoFztHeIJkJWMrx0td2f"
        },
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/7wlFDEWiM5OoIAt8RSli8b"
          },
          "href": "https://api.spotify.com/v1/artists/7wlFDEWiM5OoIAt8RSli8b",
          "id": "7wlFDEWiM5OoIAt8RSli8b",
          "name": "YoungBoy Never Broke Again",
          "type": "artist",
          "uri": "spotify:artist:7wlFDEWiM5OoIAt8RSli8b"
        },
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/50co4Is1HCEo8bhOyUWKpn"
          },
          "href": "https://api.spotify.com/v1/artists/50co4Is1HCEo8bhOyUWKpn",
          "id": "50co4Is1HCEo8bhOyUWKpn",
          "name": "Young Thug",
          "type": "artist",
          "uri": "spotify:artist:50co4Is1HCEo8bhOyUWKpn"
        }
      ],
      "available_markets": [
        "AD",
        "AE",
        "AR",
        "AT",
        "AU",
        "BE",
        "BG",
        "BH",
        "BO",
        "BR",
        "CA",
        "CH",
        "CL",
        "CO",
        "CR",
        "CY",
        "CZ",
        "DE",
        "DK",
        "DO",
        "DZ",
        "EC",
        "EE",
        "EG",
        "ES",
        "FI",
        "FR",
        "GB",
        "GR",
        "GT",
        "HK",
        "HN",
        "HU",
        "ID",
        "IE",
        "IL",
        "IN",
        "IS",
        "IT",
        "JO",
        "JP",
        "KW",
        "LB",
        "LI",
        "LT",
        "LU",
        "LV",
        "MA",
        "MC",
        "MT",
        "MX",
        "MY",
        "NI",
        "NL",
        "NO",
        "NZ",
        "OM",
        "PA",
        "PE",
        "PH",
        "PL",
        "PS",
        "PT",
        "PY",
        "QA",
        "RO",
        "SA",
        "SE",
        "SG",
        "SK",
        "SV",
        "TH",
        "TN",
        "TR",
        "TW",
        "US",
        "UY",
        "VN",
        "ZA"
      ],
      "disc_number": 1,
      "duration_ms": 212660,
      "explicit": true,
      "external_ids": {"isrc": "USUG11701371"},
      "external_urls": {
        "spotify": "https://open.spotify.com/track/3VvHSQ2x6PqKYe4MBgxV0a"
      },
      "href": "https://api.spotify.com/v1/tracks/3VvHSQ2x6PqKYe4MBgxV0a",
      "id": "3VvHSQ2x6PqKYe4MBgxV0a",
      "is_local": false,
      "name": "Mandatory Drug Test (feat. Young Thug)",
      "popularity": 56,
      "preview_url": null,
      "track_number": 3,
      "type": "track",
      "uri": "spotify:track:3VvHSQ2x6PqKYe4MBgxV0a"
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
      onPressed: () => {},
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
      arguments: null,
    );
  }
}
