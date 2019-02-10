import 'package:yes_music/models/payer_options_model.dart';
import 'package:yes_music/models/player_restrictions_model.dart';
import 'package:yes_music/models/track_model.dart';

/// A data model for a player state as returned by the Spotify API.
class PlayerStateModel {
  final bool isPaused;
  final PlayerOptionsModel playbackOptions;
  final int playbackPosition;
  final PlayerRestrictionsModel playbackRestrictions;
  final double playbackSpeed;
  final TrackModel track;

  PlayerStateModel.fromMap(Map map)
      : this.isPaused = map['isPaused'],
        this.playbackOptions =
            new PlayerOptionsModel.fromMap(map['playbackOptions']),
        this.playbackPosition = map['playbackPosition'],
        this.playbackRestrictions =
            new PlayerRestrictionsModel.fromMap(map['playbackRestrictions']),
        this.playbackSpeed = map['playbackSpeed'],
        this.track = new TrackModel.fromMap(map['track']);
}
