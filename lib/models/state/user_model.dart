/// A user in a session.
class UserModel {
  /// This user's user ID.
  final String uid;

  /// The current search for this user.
  final String searchQuery;

  UserModel(this.uid, this.searchQuery);

  UserModel.fromMap(Map map)
      : uid = map["uid"],
        searchQuery = map["searchQuery"];

  static List<UserModel> fromMapList(List maps) {
    return maps?.map((map) => new UserModel.fromMap(map))?.toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "searchQuery": searchQuery,
    };
  }

  static List<Map<String, dynamic>> toMapList(List<UserModel> models) {
    return models?.map((model) => model.toMap())?.toList();
  }

  @override
  bool operator ==(other) =>
      other is UserModel &&
      other.uid == uid &&
      other.searchQuery == searchQuery;

  @override
  int get hashCode => uid.hashCode ^ searchQuery.hashCode;
}
