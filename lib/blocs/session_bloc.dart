import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/transaction_handler_base.dart';

/// An enumeration of the states that a session can be in. Note that the
/// "ENDED" value is purely client-side; if a user ends a session that they are
/// not the host of, the session will persist without them.
enum SessionState {
  ACTIVE,
  LEAVING,
  LEFT,
}

/// A bloc that handles managing a session.
class SessionBloc implements BlocBase {
  final TransactionHandlerBase transactionHandler =
      FirebaseProvider().getTransactionHandler();

  /// A [BehaviorSubject] that broadcasts the current state of the session.
  final BehaviorSubject<SessionState> _stateSubject =
      BehaviorSubject.seeded(SessionState.ACTIVE);

  ValueObservable<SessionState> get stateStream => _stateSubject.stream;

  StreamSink<SessionState> get stateSink => _stateSubject.sink;

  /// A subscription to the session state.
  StreamSubscription<SessionState> _stateSub;

  SessionBloc() {
    _stateSub = _stateSubject.listen((SessionState state) {
      switch (state) {
        case SessionState.LEAVING:
          // Handle the user attempting to leave the session.
          _leaveSession();
          break;
        default:
          break;
      }
    });
  }

  /// Leaves the current session.
  void _leaveSession() async {
    try {
      await transactionHandler.leaveSession();
    } on StateError catch (e) {
      _stateSubject.addError(e);
    }

    _stateSubject.add(SessionState.LEFT);
  }

  @override
  void dispose() {
    _stateSub.cancel();
    _stateSubject.close();
  }
}
