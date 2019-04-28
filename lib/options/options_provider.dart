import 'package:yes_music/data/flavor.dart';
import 'package:yes_music/options/options_handler.dart';
import 'package:yes_music/options/options_handler_base.dart';

class OptionsProvider {
  Flavor _flavor = Flavor.REMOTE;
  OptionsHandlerBase _optionsHandler;

  /// A singleton instance of the options provider.
  static final OptionsProvider _instance = OptionsProvider._internal();

  factory OptionsProvider() => _instance;

  OptionsProvider._internal();

  /// Sets the [Flavor] to use when making option requests.
  void setFlavor(Flavor flavor) {
    _flavor = flavor;
  }

  OptionsHandlerBase getOptionsHandler() {
    switch (_flavor) {
      case Flavor.REMOTE:
        if (_optionsHandler == null) {
          _optionsHandler = OptionsHandler();
        }

        return _optionsHandler;
        break;
      case Flavor.MOCK:
        throw UnimplementedError("Mock options handler not yet implemented.");
      default:
        throw StateError("Option provider flavor not set");
        break;
    }
  }
}