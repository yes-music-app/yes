/// A data model for the player restrictions as returned by the Spotify API.
class PlayerRestrictionsModel {
  final bool canRepeatContext;
  final bool canRepeatTrack;
  final bool canSeek;
  final bool canSkipNext;
  final bool canSkipPrev;
  final bool canToggleShuffle;

  PlayerRestrictionsModel.fromMap(Map map)
      : this.canRepeatContext = map['canRepeatContext'],
        this.canRepeatTrack = map['canRepeatTrack'],
        this.canSeek = map['canSeek'],
        this.canSkipNext = map['canSkipNext'],
        this.canSkipPrev = map['canSkipPrev'],
        this.canToggleShuffle = map['canToggleShuffle'];
}
