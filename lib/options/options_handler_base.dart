import 'package:yes_music/models/state/options_model.dart';

/// A class that handles the persisting of options to local storage.
abstract class OptionsHandlerBase {
  /// Sets the given default option for the given user.
  void setDefaultOption(String key, dynamic value, String uid);

  /// Gets the default options for the user with the given [uid].
  Future<OptionsModel> getDefaultOptions(String uid);
}