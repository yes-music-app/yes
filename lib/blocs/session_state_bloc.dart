import 'dart:async';
import 'dart:math';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/auth_handler_base.dart';
import 'package:yes_music/data/firebase/data_utils.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/session_state_handler_base.dart';
import 'package:yes_music/models/state/search_model.dart';
import 'package:yes_music/models/state/session_model.dart';
import 'package:yes_music/models/state/user_model.dart';

/// An enumeration of the states that a session can be in. Note that the
/// "ENDED" value is purely client-side; if a user ends a session that they are
/// not the host of, the session will persist without them.
enum SessionState {
  INACTIVE,
  REJOINING,
  CHOOSING,
  AWAITING_SID,
  JOINING,
  CREATING,
  CREATED,
  ACTIVE,
  LEAVING,
}

/// A bloc that handles managing session state.
class SessionStateBloc implements BlocBase {
  /// A reference to the auth handler.
  final AuthHandlerBase _authHandler = FirebaseProvider().getAuthHandler();

  /// A reference to the session handler.
  final SessionStateHandlerBase _stateHandler =
      FirebaseProvider().getSessionStateHandler();

  /// A [BehaviorSubject] that broadcasts the current state of the session.
  final BehaviorSubject<SessionState> _stateSubject =
      BehaviorSubject.seeded(SessionState.INACTIVE);

  ValueObservable<SessionState> get stream => _stateSubject.stream;

  StreamSink<SessionState> get sink => _stateSubject.sink;

  /// A subscription to the session state.
  StreamSubscription<SessionState> _stateSub;

  SessionStateBloc() {
    _stateSub = _stateSubject.listen((SessionState state) {
      switch (state) {
        case SessionState.REJOINING:
          _rejoinSession();
          break;
        case SessionState.LEAVING:
          _leaveSession();
          break;
        case SessionState.CREATING:
          _createSession();
          break;
        default:
          break;
      }
    });
  }

  /// Joins a session with the given sid.
  void joinSession(String sid) {
    if (_stateSubject.value == SessionState.AWAITING_SID) {
      _stateSubject.add(SessionState.JOINING);
      _joinSession(sid);
    }
  }

  /// A getter for the session ID.
  String sid({bool checked = false}) => _stateHandler.sid(checked: checked);

  /// Attempts to rejoin a session.
  void _rejoinSession() async {
    final bool joined = await _stateHandler.rejoinSession().catchError((e) {
      _stateSubject.addError(e);
      return;
    });

    _stateSubject.add(joined ? SessionState.ACTIVE : SessionState.CHOOSING);
  }

  /// Attempts to join a session with the given [sid].
  void _joinSession(String sid) async {
    await _stateHandler.joinSession(sid).catchError((e) {
      _stateSubject.addError(e);
    });

    _stateSubject.add(SessionState.ACTIVE);
  }

  /// Attempts to create a session.
  void _createSession() async {
    UserModel user = UserModel.empty(await _authHandler.uid());
    SessionModel model = SessionModel.empty(await _generateSID(), user);
    await _stateHandler.createSession(model).catchError((e) {
      _stateSubject.addError(e);
    });

    _stateSubject.add(SessionState.CREATED);
  }

  /// Generates a unique session ID.
  Future<String> _generateSID() async {
    String sid;

    do {
      Random random = Random();

      List<int> codes = [];
      for (int i = 0; i < 6; i++) {
        int code = random.nextInt(36);
        if (code < 10) {
          code += 48;
        } else {
          code += 55;
        }
        codes.add(code);
      }

      sid = String.fromCharCodes(codes);

      // If this session already exists, generate another sid.
      if (await sessionExists(sid)) {
        sid = null;
      }
    } while (sid == null);

    return sid;
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
