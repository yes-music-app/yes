import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/transaction_handler_base.dart';

/// The states that a rejoin attempt could be in.
enum RejoinState {
  NOT_REJOINED,
  NO_SESSION,
  SESSION_FOUND,
  JOINING_SESSION,
  SESSION_JOINED,
  LEAVING_SESSION,
  SESSION_LEFT,
}

/// Handles the re-joining of an old session that the user was in.
class RejoinBloc implements BlocBase {
  final TransactionHandlerBase transactionHandler =
      FirebaseProvider().getTransactionHandler();

  /// A [BehaviorSubject] that broadcasts the current state of rejoining.
  final BehaviorSubject<RejoinState> _stateSubject =
      BehaviorSubject.seeded(RejoinState.NOT_REJOINED);

  ValueObservable<RejoinState> get stateStream => _stateSubject.stream;

  StreamSink<RejoinState> get stateSink => _stateSubject.sink;

  /// A subscription to the rejoin state.
  StreamSubscription<RejoinState> _stateSub;

  /// The session that is to be rejoined.
  String _sid;

  String get sid => _sid;

  RejoinBloc() {
    _stateSub = _stateSubject.listen((RejoinState state) {
      switch (state) {
        case RejoinState.NOT_REJOINED:
          _findSession();
          break;
        case RejoinState.JOINING_SESSION:
          _joinSession();
          break;
        case RejoinState.LEAVING_SESSION:
          _leaveSession();
          break;
        default:
          break;
      }
    });
  }

  /// Attempts to find an old session.
  void _findSession() async {
    try {
      String oldSID = await transactionHandler.findSession();
      if (oldSID == null || oldSID.isEmpty) {
        _stateSubject.add(RejoinState.NO_SESSION);
        return;
      }
      _sid = oldSID;
    } on StateError catch (e) {
      _stateSubject.addError(e);
    }

    _stateSubject.add(RejoinState.SESSION_FOUND);
  }

  /// Attempts to find an old session.
  void _joinSession() async {
    try {
      await transactionHandler.joinSession(_sid);
    } on StateError catch (e) {
      _stateSubject.addError(e);
    }

    _stateSubject.add(RejoinState.SESSION_JOINED);
  }

  /// Attempts to leave an old session.
  void _leaveSession() async {
    try {
      await transactionHandler.leaveSession(leaveID: _sid);
    } on StateError catch (e) {
      _stateSubject.addError(e);
    }

    _stateSubject.add(RejoinState.SESSION_LEFT);
  }

  @override
  void dispose() {
    _stateSub.cancel();
    _stateSubject.close();
  }
}
