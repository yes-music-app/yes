/// A data model for the player options as returned by the Spotify API.
class PlayerOptionsModel {
  final bool isShuffling;
  final int repeatMode;

  PlayerOptionsModel.fromMap(Map map)
      : isShuffling = map["isShuffling"],
        repeatMode = map["repeatMode"];

  Map<String, dynamic> toMap() {
    return {
      "isShuffling": isShuffling,
      "repeatMode": repeatMode,
    };
  }

  @override
  bool operator ==(other) =>
      other is PlayerOptionsModel &&
      other.isShuffling == isShuffling &&
      other.repeatMode == repeatMode;

  @override
  int get hashCode => isShuffling.hashCode ^ repeatMode.hashCode;
}
