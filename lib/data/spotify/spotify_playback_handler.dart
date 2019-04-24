import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:yes_music/data/spotify/playback_handler_base.dart';
import 'package:yes_music/helpers/data_utils.dart';
import 'package:yes_music/models/spotify/player_state_model.dart';
import 'package:yes_music/models/spotify/track_model.dart';
import 'package:yes_music/models/state/search_model.dart';

/// A class that handles playback interactions with the Spotify app.
class SpotifyPlaybackHandler implements PlaybackHandlerBase {
  /// The method channel used for playback handling.
  static const MethodChannel channel =
      const MethodChannel("yes.yesmusic/playback");

  SpotifyPlaybackHandler() {
    channel.setMethodCallHandler(_handleMethod);
  }

  /// Handles method calls from native side.
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "updatePlayerState":
        _updatePlayerState(call.arguments);
        break;
      default:
        throw UnimplementedError(
            "Method called from native side not implemented.");
        break;
    }
  }

  /// An rxdart [BehaviorSubject] that publishes the current state of the music
  /// player in the Spotify app.
  BehaviorSubject<PlayerStateModel> _playerStateSubject =
      BehaviorSubject.seeded(null);

  @override
  ValueObservable<PlayerStateModel> get playerState =>
      _playerStateSubject.stream;

  /// Adds a [PlayerStateModel] to the [_playerStateSubject] stream.
  void _updatePlayerState(Map map) {
    _playerStateSubject?.add(PlayerStateModel.fromMap(map));
  }

  @override
  void subscribeToPlayerState() {
    channel.invokeMethod("subscribeToPlayerState");
  }

  @override
  void unsubscribeFromPlayerState() {
    channel.invokeMethod("unsubscribeFromPlayerState");
  }

  @override
  void resume() {
    channel.invokeMethod("resume");
  }

  @override
  void pause() {
    channel.invokeMethod("pause");
  }

  @override
  void skipNext() {
    channel.invokeMethod("skipNext");
  }

  @override
  void skipPrevious() {
    channel.invokeMethod("skipPrevious");
  }

  @override
  void seekTo(int position) {
    channel.invokeMethod("seekTo", position);
  }

  @override
  void play(String trackUri) {
    channel.invokeMethod("play", trackUri);
  }

  @override
  void queue(String trackUri) {
    channel.invokeMethod("queue", trackUri);
  }

  @override
  Future<Image> getImage(String imageUri) async {
    Map map = await channel.invokeMethod("getImage", imageUri);
    if (map == null) {
      return null;
    }

    return Image.memory(
      map['bytes'],
      width: map['width'],
      height: map['height'],
    );
  }

  @override
  void dispose() {
    _playerStateSubject.close();
  }

  /// Searches with the given [query], using [accessToken] for authorization.
  @override
  Future<SearchModel> search(
    String query,
    String accessToken, {
    int limit = 20,
    int offset = 0,
  }) async {
    // The url of the search endpoint.
    final baseUrl = "https://api.spotify.com/v1/search";
    final Map<String, String> params = {
      "q": query,
      "type": "track",
      "limit": limit.toString(),
      "offset": offset.toString(),
    };

    // Set the auth header with the access token.
    final Map<String, String> headers = {
      "Authorization": "Bearer " + accessToken,
    };

    // Perform a search query on the generated url.
    dynamic res = await http.get(
      generateUrl(baseUrl, params),
      headers: headers,
    );

    // Decode the received objects.
    final Map items = jsonDecode(res.body);
    List<TrackModel> tracks = TrackModel.mapTracks(items["tracks"]["items"]);
    int total = items["tracks"]["total"];

    return SearchModel(tracks, total - tracks.length - offset);
  }
}
