import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/transaction_handler_base.dart';

enum RejoinState {
  NOT_REJOINED,
  NO_SESSION,
  SESSION_FOUND,
  JOINING_SESSION,
  SESSION_JOINED,
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
          _rejoinSession();
          break;
        case RejoinState.JOINING_SESSION:
          _joinSession();
          break;
        default:
          break;
      }
    });
  }

  /// Attempts to rejoin an old session.
  void _rejoinSession() async {
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

  void _joinSession() async {
    try {
      await transactionHandler.joinSession(_sid);
    } on StateError catch (e) {
      _stateSubject.addError(e);
    }

    _stateSubject.add(RejoinState.SESSION_JOINED);
  }

  @override
  void dispose() {
    _stateSub.cancel();
    _stateSubject.close();
  }
}
