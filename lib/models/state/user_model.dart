/// A user in a session.
class UserModel {
  /// This user's user ID.
  final String uid;

  UserModel.empty(this.uid);

  UserModel.fromMap(Map map) : uid = map["uid"];

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
  bool operator ==(other) => other is UserModel && other.uid == uid;

  @override
  int get hashCode => uid.hashCode;
}
