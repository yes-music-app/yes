import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/transaction_handler_base.dart';

/// An enumeration of the potential states that a create operation can be in.
enum CreateSessionState {
  NOT_CREATED,
  CREATING,
  CREATED,
}

/// A bloc that handles creating a session.
class CreateBloc implements BlocBase {
  /// The [TransactionHandlerBase] that performs the create operation.
  final TransactionHandlerBase _transactionHandler =
      FirebaseProvider().getTransactionHandler();

  /// The [BehaviorSubject] that broadcasts the current state of the user's
  /// attempt to create a session.
  BehaviorSubject<CreateSessionState> _createState = BehaviorSubject(
    seedValue: CreateSessionState.NOT_CREATED,
  );

  ValueObservable<CreateSessionState> get stream => _createState.stream;

  StreamSink<CreateSessionState> get sink => _createState.sink;

  /// A subscription to the create state.
  StreamSubscription<CreateSessionState> _sub;

  /// A getter for the session sid.
  String get sid => _transactionHandler.sid;

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
      _createState.addError(e);
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    _createState.close();
  }
}
