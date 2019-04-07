import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/transaction_handler_base.dart';

/// An enumeration of the potential states that a join operation can be in.
enum JoinSessionState {
  NOT_JOINED,
  JOINING,
  JOINED,
}

/// A bloc that handles joining a session.
class JoinBloc implements BlocBase {
  /// The [TransactionHandlerBase] that performs the join operation.
  final TransactionHandlerBase _transactionHandler =
      FirebaseProvider().getTransactionHandler();

  /// The [BehaviorSubject] that broadcasts the current state of the user's
  /// attempt to join a session.
  BehaviorSubject<JoinSessionState> _joinState = BehaviorSubject(
    seedValue: JoinSessionState.NOT_JOINED,
  );

  ValueObservable<JoinSessionState> get stream => _joinState.stream;

  StreamSink<JoinSessionState> get sink => _joinState.sink;

  /// The [BehaviorSubject] that reads the session ID inputs from the UI.
  BehaviorSubject<String> _sid = BehaviorSubject();

  StreamSink<String> get sidSink => _sid.sink;

  /// A subscription to the session ID input stream.
  StreamSubscription<String> _sub;

  JoinBloc() {
    _sub = _sid.listen((String sid) {
      // If we receive a session ID and we are not currently joining a room or
      // already in one, try to join a new one.
      if (_joinState.value == JoinSessionState.NOT_JOINED) {
        _joinState.add(JoinSessionState.JOINING);
        _joinSession(sid);
      }
    });
  }

  /// Attempts to join the session with the given session ID.
  void _joinSession(String sid) async {
    _transactionHandler.joinSession(sid).then((_) {
      _joinState.add(JoinSessionState.JOINED);
    }).catchError((e) {
      StateError error = e is StateError ? e : StateError("errors.unknown");
      _joinState.addError(error);
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    _joinState.close();
    _sid.close();
  }
}
