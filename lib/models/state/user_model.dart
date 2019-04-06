import 'package:yes_music/models/state/search_model.dart';

/// A user in a session.
class UserModel {
  /// This user's user ID.
  final String uid;

  /// The current search for this user.
  final SearchModel search;

  UserModel(this.uid, this.search);

  UserModel.fromMap(Map map)
      : uid = map["uid"],
        search = SearchModel.fromMap(map["search"]);

  static List<UserModel> fromMapList(List maps) {
    return maps?.map((map) => UserModel.fromMap(map))?.toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "searchQuery": search.toMap(),
    };
  }

  static List<Map<String, dynamic>> toMapList(List<UserModel> models) {
    return models?.map((model) => model.toMap())?.toList();
  }

  @override
  bool operator ==(other) =>
      other is UserModel &&
      other.uid == uid &&
      other.search == search;

  @override
  int get hashCode => uid.hashCode ^ search.hashCode;
}
