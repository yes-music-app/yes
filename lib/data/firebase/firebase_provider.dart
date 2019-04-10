import 'package:yes_music/data/firebase/auth_handler_base.dart';
import 'package:yes_music/data/firebase/firebase_auth_handler.dart';
import 'package:yes_music/data/firebase/firebase_session_handler.dart';
import 'package:yes_music/data/firebase/firebase_transaction_handler.dart';
import 'package:yes_music/data/firebase/session_handler_base.dart';
import 'package:yes_music/data/firebase/transaction_handler_base.dart';
import 'package:yes_music/data/flavor.dart';

class FirebaseProvider {
  Flavor _flavor;
  AuthHandlerBase _authHandler;
  TransactionHandlerBase _transactionHandler;
  SessionHandlerBase _sessionHandler;

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

  TransactionHandlerBase getTransactionHandler() {
    switch (_flavor) {
      case Flavor.REMOTE:
        if (_transactionHandler == null) {
          _transactionHandler = FirebaseTransactionHandler();
        }

        return _transactionHandler;
      case Flavor.MOCK:
        throw UnimplementedError(
            "Mock transaction handler not yet implemented.");
      default:
        throw StateError("Firebase provider flavor not set");
        break;
    }
  }

  SessionHandlerBase getSessionHandler() {
    switch (_flavor) {
      case Flavor.REMOTE:
        if (_sessionHandler == null) {
          _sessionHandler = FirebaseSessionHandler();
        }

        return _sessionHandler;
      case Flavor.MOCK:
        throw UnimplementedError("Mock session handler not yet implemented.");
      default:
        throw StateError("Firebase provider flavor not set");
    }
  }
}
