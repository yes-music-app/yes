import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';

/// An enumeration of the states that a session can be in. Note that the
/// "ENDED" value is purely client-side; if a user ends a session that they are
/// not the host of, the session will persist without them.
enum SessionState {
  ACTIVE,
  ENDED,
}

/// A bloc that handles managing a session.
class SessionBloc implements BlocBase {
  /// A [BehaviorSubject] that broadcasts the current state of the session.
  final BehaviorSubject<SessionState> _sessionSubject = BehaviorSubject(
    seedValue: SessionState.ACTIVE,
  );

  ValueObservable<SessionState> get sessionStream => _sessionSubject.stream;

  StreamSink<SessionState> get sessionSink => _sessionSubject.sink;

  /// A subscription to the session state.
  StreamSubscription<SessionState> _sessionSub;

  SessionBloc() {
    _sessionSub = _sessionSubject.listen((SessionState state) {
      switch (state) {
        case SessionState.ENDED:
          // If the user tries to end the session, leave it.
          break;
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    _sessionSub.cancel();
    _sessionSubject.close();
  }
}
