import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/session_state_handler_base.dart';

/// The states that a rejoin attempt could be in.
enum RejoinState {
  NOT_REJOINED,
  NO_SESSION,
  SESSION_JOINED,
}

/// Handles the re-joining of an old session that the user was in.
class RejoinBloc implements BlocBase {
  final SessionStateHandlerBase _stateHandler =
      FirebaseProvider().getSessionStateHandler();

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
    // Create a subscription to the rejoin bloc's state stream.
    _stateSub = _stateSubject.listen((RejoinState state) {
      switch (state) {
        case RejoinState.NOT_REJOINED:
          // If we receive a zero state event, search for a session to rejoin.
          _rejoinSession();
          break;
        default:
          break;
      }
    });
  }

  /// Attempts to find an old session.
  void _rejoinSession() async {
    bool joined = false;

    try {
      // Attempt to rejoin a session.
      joined = await _stateHandler.rejoinSession();
    } catch (e) {
      // If a call throws an error, push the error through the state stream.
      _stateSubject.addError(e);
      return;
    }

    _stateSubject.add(
      joined ? RejoinState.SESSION_JOINED : RejoinState.NO_SESSION,
    );
  }

  @override
  void dispose() {
    _stateSub.cancel();
    _stateSubject.close();
  }
}
