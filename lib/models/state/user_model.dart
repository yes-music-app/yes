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
        search = new SearchModel.fromMap(map["search"]);

  static List<UserModel> fromMapList(Map maps) {
    List<UserModel> models = List();

    maps?.values?.forEach((value) {
      models.add(UserModel.fromMap(value));
    });

    return models;
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "searchQuery": search.toMap(),
    };
  }

  static Map<String, dynamic> toMapList(List<UserModel> models) {
    final Map<String, dynamic> map = Map();

    models?.forEach((UserModel model) {
      map[model.uid] = model.toMap();
    });

    return map;
  }

  @override
  bool operator ==(other) =>
      other is UserModel && other.uid == uid && other.search == search;

  @override
  int get hashCode => uid.hashCode ^ search.hashCode;
}
