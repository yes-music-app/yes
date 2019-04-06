import 'package:yes_music/feature_flags/index.dart';

class FlagProvider {
  static final FlagProvider instance = FlagProvider._internal();

  FlagProvider._internal();

  factory FlagProvider() => instance;

  bool getFlag(String key) {
    return flagMap.containsKey(key) && flagMap[key];
  }
}
