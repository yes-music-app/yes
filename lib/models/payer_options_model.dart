/// A data model for the player options as returned by the Spotify API.
class PlayerOptionsModel {
  final bool isShuffling;
  final int repeatMode;

  PlayerOptionsModel.fromMap(Map map)
      : this.isShuffling = map['isShuffling'],
        this.repeatMode = map['repeatMode'];
}
