import 'package:yes_music/data/firebase/auth_handler_base.dart';
import 'package:yes_music/data/firebase/firebase_auth_handler.dart';
import 'package:yes_music/data/flavor.dart';

class AuthProvider {
  Flavor _flavor;
  AuthHandlerBase _authHandler;

  /// A singleton instance of the Firebase provider.
  static final AuthProvider _instance = new AuthProvider._internal();

  factory AuthProvider() => _instance;

  AuthProvider._internal();

  /// Sets the [Flavor] to use when making Firebase requests.
  void setFlavor(Flavor flavor) {
    _flavor = flavor;
  }

  AuthHandlerBase getAuthHandler() {
    switch (_flavor) {
      case Flavor.REMOTE:
        if (_authHandler == null) {
          _authHandler = new FirebaseAuthHandler();
        }

        return _authHandler;
        break;
      default:
        throw new StateError("Firebase provider flavor not set");
        break;
    }
  }
}
