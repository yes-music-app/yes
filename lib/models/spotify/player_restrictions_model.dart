/// A data model for the player restrictions as returned by the Spotify API.
class PlayerRestrictionsModel {
  final bool canRepeatContext;
  final bool canRepeatTrack;
  final bool canSeek;
  final bool canSkipNext;
  final bool canSkipPrev;
  final bool canToggleShuffle;

  PlayerRestrictionsModel.fromMap(Map map)
      : canRepeatContext = map["canRepeatContext"],
        canRepeatTrack = map["canRepeatTrack"],
        canSeek = map["canSeek"],
        canSkipNext = map["canSkipNext"],
        canSkipPrev = map["canSkipPrev"],
        canToggleShuffle = map["canToggleShuffle"];

  Map<String, dynamic> toMap() {
    return {
      "canRepeatContext": canRepeatContext,
      "canRepeatTrack": canRepeatTrack,
      "canSeek": canSeek,
      "canSkipNext": canSkipNext,
      "canSkipPrev": canSkipPrev,
      "canToggleShuffle": canToggleShuffle,
    };
  }
}
