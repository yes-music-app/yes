import 'package:yes_music/options/index.dart';

class FlagProvider {
  static final FlagProvider instance = FlagProvider._internal();

  FlagProvider._internal();

  factory FlagProvider() => instance;

  bool getFlag(String key) {
    return flagMap.containsKey(key) && flagMap[key];
  }
}
