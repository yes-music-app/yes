const String TOKENS_PATH = "tokens";
const String ACCESS_TOKEN_PATH = "accessToken";
const String REFRESH_TOKEN_PATH = "refreshToken";
const String TOKEN_DIRTY_PATH = "tokenDirty";

/// A collection of tokens that can be used to authorize connections to Spotify
/// endpoints.
class TokenModel {
  /// A token that gives us authorization to hit Spotify endpoints.
  final String accessToken;

  /// A token that allows us to acquire a refreshed access token if needed.
  final String refreshToken;

  /// Whether we need to request a new access token.
  final bool tokenDirty;

  /// Create a new token model.
  TokenModel.initial(this.accessToken, this.refreshToken) : tokenDirty = false;

  /// Create a token model from a map.
  TokenModel.fromMap(Map map)
      : accessToken = map[ACCESS_TOKEN_PATH],
        refreshToken = map[REFRESH_TOKEN_PATH],
        tokenDirty = map[TOKEN_DIRTY_PATH];

  /// Create a token model from an old model.
  TokenModel.fromModel(
    TokenModel old, {
    String newAccess,
    String newRefresh,
    bool newDirty,
  })  : accessToken = newAccess == null ? old.accessToken : newAccess,
        refreshToken = newRefresh == null ? old.refreshToken : newRefresh,
        tokenDirty = newDirty == null ? old.tokenDirty : newDirty;

  /// Convert this token model into a map.
  Map<String, dynamic> toMap() {
    return {
      ACCESS_TOKEN_PATH: accessToken,
      REFRESH_TOKEN_PATH: refreshToken,
      TOKEN_DIRTY_PATH: tokenDirty,
    };
  }

  @override
  bool operator ==(other) =>
      other is TokenModel &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken &&
      other.tokenDirty == tokenDirty;

  @override
  int get hashCode =>
      accessToken.hashCode ^
      refreshToken.hashCode ^
      tokenDirty.hashCode;
}
