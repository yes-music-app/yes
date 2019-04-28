/// The various options available to the user. If adding to these options, be
/// sure to add the new option to the [OPTIONS] list below.
const List<MapEntry<String, dynamic>> OPTIONS = [
  HOST_DELETE,
];

const MapEntry<String, bool> HOST_DELETE = MapEntry("host_delete", false);

/// A class describing the possible options a session can have.
class OptionsModel {
  /// The map containing the option values.
  final Map<String, dynamic> _options;

  /// Creates an [OptionsModel] from the given map.
  OptionsModel(this._options);

  /// Creates an [OptionsMode] from a JSON map.
  OptionsModel.fromMap(Map map) : _options = map.cast<String, dynamic>();

  /// Converts this model to a map.
  Map<String, dynamic> toMap() {
    return _options;
  }

  /// Sets an option in this model.
  Future setOption(String key, dynamic value) async {
    switch(value.runtimeType) {
      case int:
      case bool:
        break;
      default:
        throw StateError("errors.options.invalidValue");
    }

    _options[key] = value;
  }
}
