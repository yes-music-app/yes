import 'package:yes_music/models/spotify/player_options_model.dart';
import 'package:yes_music/models/spotify/player_restrictions_model.dart';
import 'package:yes_music/models/spotify/track_model.dart';

/// A data model for a player state as returned by the Spotify API.
class PlayerStateModel {
  final bool isPaused;
  final PlayerOptionsModel playbackOptions;
  final int playbackPosition;
  final PlayerRestrictionsModel playbackRestrictions;
  final double playbackSpeed;
  final TrackModel track;

  PlayerStateModel.fromMap(Map map)
      : isPaused = map['isPaused'],
        playbackOptions =
            new PlayerOptionsModel.fromMap(map['playbackOptions']),
        playbackPosition = map['playbackPosition'],
        playbackRestrictions =
            new PlayerRestrictionsModel.fromMap(map['playbackRestrictions']),
        playbackSpeed = map['playbackSpeed'],
        track = new TrackModel.fromMap(map['track']);
}
