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
      : isPaused = map["isPaused"],
        playbackOptions = PlayerOptionsModel.fromMap(map["playbackOptions"]),
        playbackPosition = map["playbackPosition"],
        playbackRestrictions =
            PlayerRestrictionsModel.fromMap(map["playbackRestrictions"]),
        playbackSpeed = map["playbackSpeed"],
        track = TrackModel.fromMap(map["track"]);

  Map<String, dynamic> toMap() {
    return {
      "isPaused": isPaused,
      "playbackOptions": playbackOptions.toMap(),
      "playbackPosition": playbackPosition,
      "playbackRestrictions": playbackRestrictions,
      "playbackSpeed": playbackSpeed,
      "track": track.toMap(),
    };
  }

  @override
  bool operator ==(other) =>
      other is PlayerStateModel &&
      other.isPaused == isPaused &&
      other.playbackOptions == playbackOptions &&
      other.playbackPosition == playbackPosition &&
      other.playbackRestrictions == playbackRestrictions &&
      other.playbackSpeed == playbackSpeed &&
      other.track == track;
}
