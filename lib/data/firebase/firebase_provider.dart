import 'package:yes_music/data/firebase/auth_handler_base.dart';
import 'package:yes_music/data/firebase/firebase_auth_handler.dart';
import 'package:yes_music/data/firebase/firebase_transaction_handler.dart';
import 'package:yes_music/data/firebase/transaction_handler_base.dart';
import 'package:yes_music/data/flavor.dart';

class FirebaseProvider {
  Flavor _flavor;
  AuthHandlerBase _authHandler;
  TransactionHandlerBase _transactionHandler;

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
        break;
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
        break;
      default:
        throw StateError("Firebase provider flavor not set");
        break;
    }
  }
}
