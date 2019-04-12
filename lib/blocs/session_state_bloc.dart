import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/session_state_handler_base.dart';

/// An enumeration of the states that a session can be in. Note that the
/// "ENDED" value is purely client-side; if a user ends a session that they are
/// not the host of, the session will persist without them.
enum SessionState {
  INACTIVE,
  REJOINING,
  CHOOSING,
  JOINING,
  CREATING,
  CREATED,
  ACTIVE,
  LEAVING,
}

/// A bloc that handles managing session state.
class SessionStateBloc implements BlocBase {
  /// A reference to the session handler.
  final SessionStateHandlerBase _stateHandler =
      FirebaseProvider().getSessionStateHandler();

  /// A [BehaviorSubject] that broadcasts the current state of the session.
  final BehaviorSubject<SessionState> _stateSubject =
      BehaviorSubject.seeded(SessionState.INACTIVE);

  ValueObservable<SessionState> get stateStream => _stateSubject.stream;

  StreamSink<SessionState> get stateSink => _stateSubject.sink;

  /// A subscription to the session state.
  StreamSubscription<SessionState> _stateSub;

  SessionStateBloc() {
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
    await _stateHandler.leaveSession().catchError((e) {
      _stateSubject.addError(e);
      return;
    });

    _stateSubject.add(SessionState.INACTIVE);
  }

  @override
  void dispose() {
    _stateSub.cancel();
    _stateSubject.close();
  }
}
