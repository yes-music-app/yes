import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/firebase_transaction_handler.dart';

/// An enumeration of the potential states that a create operation can be in.
enum CreateSessionState {
  NOT_CREATED,
  CREATING,
  CREATED,
}

/// A bloc that handles creating a session.
class CreateBloc implements BlocBase {
  /// The [FirebaseTransactionHandler] that performs the create operation.
  final FirebaseTransactionHandler _transactionHandler =
      new FirebaseProvider().getTransactionHandler();

  /// The [BehaviorSubject] that broadcasts the current state of the user's
  /// attempt to create a session.
  BehaviorSubject<CreateSessionState> _createState = new BehaviorSubject(
    seedValue: CreateSessionState.NOT_CREATED,
  );

  ValueObservable<CreateSessionState> get stream => _createState.stream;

  StreamSink<CreateSessionState> get sink => _createState.sink;

  /// A subscription to the create state.
  StreamSubscription<CreateSessionState> _sub;

  CreateBloc() {
    _sub = _createState.listen((CreateSessionState state) {
      switch (state) {
        case CreateSessionState.CREATING:
          _createSession();
          break;
        default:
          break;
      }
    });
  }

  /// Attempts to create a new session.
  void _createSession() {
    _transactionHandler.createSession().then((_) {
      _createState.add(CreateSessionState.CREATED);
    }).catchError((e) {
      StateError error = e is StateError ? e : new StateError("errors.unknown");
      _createState.addError(error);
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    _createState.close();
  }
}
