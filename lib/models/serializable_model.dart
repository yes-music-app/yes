abstract class SerializableModel {
  String get identifier;

  Map<String, dynamic> toMap();

  static SerializableModel fromMap(Map map) {
    throw UnimplementedError("Searchable fromMap constructor not implemented.");
  }

  static List<T> fromMapList<T extends SerializableModel>(Map<String, dynamic> maps) {
    final List<T> models = new List();

    maps.forEach((String key, value) {
      if (value != null && value is Map) {
        models.add(fromMap(value));
      }
    });

    return models;
  }

  static Map<String, dynamic> toMapList(List<SerializableModel> models) {
    final Map<String, dynamic> map = new Map();

    models?.forEach((SerializableModel model) {
      if(model != null) {
        map[model.identifier] = model.toMap();
      }
    });

    return map;
  }
}

