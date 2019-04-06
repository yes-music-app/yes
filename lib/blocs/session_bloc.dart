import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/auth_handler_base.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';

/// An enumeration of the states that a session can be in. Note that the
/// "ENDED" value is purely client-side; if a user ends a session that they are
/// not the host of, the session will persist without them.
enum SessionState {
  ACTIVE,
  SIGNING_OUT,
  LEAVING,
  LEFT,
}

/// A bloc that handles managing a session.
class SessionBloc implements BlocBase {
  final AuthHandlerBase _authHandler = FirebaseProvider().getAuthHandler();

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
        case SessionState.SIGNING_OUT:
          // Handle the user attempting to log out.
          _logout();
          break;
        case SessionState.LEAVING:
          // Handle the user attempting to leave the session.
          _leaveSession();
          break;
        default:
          break;
      }
    });
  }

  /// Signs the user out from their Google account and then leaves the current
  /// session.
  void _logout() {
    _authHandler.signOut();
    _sessionSubject.add(SessionState.LEAVING);
  }

  /// Leaves the current session.
  void _leaveSession() {
    _sessionSubject.add(SessionState.LEFT);
  }

  @override
  void dispose() {
    _sessionSub.cancel();
    _sessionSubject.close();
  }
}
