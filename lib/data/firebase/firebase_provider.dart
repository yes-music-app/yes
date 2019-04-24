import 'package:yes_music/data/firebase/auth_handler_base.dart';
import 'package:yes_music/data/firebase/firebase_auth_handler.dart';
import 'package:yes_music/data/firebase/session_data_handler.dart';
import 'package:yes_music/data/firebase/session_data_handler_base.dart';
import 'package:yes_music/data/firebase/session_state_handler.dart';
import 'package:yes_music/data/firebase/session_state_handler_base.dart';
import 'package:yes_music/data/flavor.dart';

class FirebaseProvider {
  Flavor _flavor = Flavor.REMOTE;
  AuthHandlerBase _authHandler;
  SessionStateHandlerBase _sessionHandler;
  SessionDataHandlerBase _dataHandler;

  /// A singleton instance of the Firebase provider.
  static final FirebaseProvider _instance = FirebaseProvider._internal();

  factory FirebaseProvider() => _instance;

  FirebaseProvider._internal();

  /// Sets the [Flavor] to use when making Firebase requests.
  void setFlavor(Flavor flavor) {
    _flavor = flavor;
  }

  AuthHandlerBase getAuthHandler() {
    switch (_flavor) {
      case Flavor.REMOTE:
        if (_authHandler == null) {
          _authHandler = FirebaseAuthHandler();
        }

        return _authHandler;
      case Flavor.MOCK:
        throw UnimplementedError("Mock auth handler not yet implemented.");
      default:
        throw StateError("Firebase provider flavor not set");
        break;
    }
  }

  SessionStateHandlerBase getSessionStateHandler() {
    switch (_flavor) {
      case Flavor.REMOTE:
        if (_sessionHandler == null) {
          _sessionHandler = SessionStateHandler();
        }

        return _sessionHandler;
      case Flavor.MOCK:
        throw UnimplementedError("Mock session handler not yet implemented.");
      default:
        throw StateError("Firebase provider flavor not set");
    }
  }

  SessionDataHandlerBase getSessionDataHandler() {
    switch (_flavor) {
      case Flavor.REMOTE:
        if (_dataHandler == null) {
          _dataHandler = SessionDataHandler();
        }

        return _dataHandler;
      case Flavor.MOCK:
        throw UnimplementedError("Mock data handler not yet implemented.");
      default:
        throw StateError("Firebase provider flavor not set");
    }
  }
}
