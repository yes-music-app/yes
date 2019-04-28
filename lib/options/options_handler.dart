import 'package:shared_preferences/shared_preferences.dart';
import 'package:yes_music/models/state/options_model.dart';
import 'package:yes_music/options/options_handler_base.dart';

/// A class that handles the setting of default options in the local storage.
class OptionsHandler implements OptionsHandlerBase {
  @override
  void setDefaultOption(String key, dynamic value, String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    switch (value.runtimeType) {
      case int:
        preferences.setInt(key, value);
        break;
      case bool:
        preferences.setBool(key, value);
        break;
      default:
        throw StateError("errors.options.invalidValue");
    }
  }

  @override
  Future<OptionsModel> getDefaultOptions(String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> options = {};

    // Run through the possible options and get either the stored option or the
    // app defaults.
    OPTIONS.forEach((MapEntry<String, dynamic> entry) {
      switch (entry.value.runtimeType) {
        case int:
          options[entry.key] =
              preferences.getInt(_getKey(entry.key, uid)) ?? entry.value;
          break;
        case bool:
          options[entry.key] =
              preferences.getBool(_getKey(entry.key, uid)) ?? entry.value;
          break;
        default:
          throw StateError("errors.options.invalidValue");
      }
    });

    return OptionsModel(options);
  }

  /// Gets an option key for the given user.
  String _getKey(String key, String uid) => uid + ":" + key;
}
