import 'dart:async';
import 'dart:math';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/auth_handler_base.dart';
import 'package:yes_music/data/firebase/data_utils.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/session_state_handler_base.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';
import 'package:yes_music/data/spotify/spotify_provider.dart';
import 'package:yes_music/data/spotify/token_handler_base.dart';
import 'package:yes_music/models/spotify/token_model.dart';
import 'package:yes_music/models/state/session_model.dart';
import 'package:yes_music/models/state/user_model.dart';

/// An enumeration of the states that a session can be in. Note that the
/// "INACTIVE" value is purely client-side; if a user ends a session that they are
/// not the host of, the session will persist without them.
enum SessionState {
  INACTIVE,
  REJOINING,
  CHOOSING,
  AWAITING_SID,
  JOINING,
  AWAITING_URL,
  AWAITING_TOKENS,
  AWAITING_CONNECTION,
  CREATING,
  CREATED,
  ACTIVE,
  LEAVING,
}

/// A bloc that handles managing session state.
class SessionStateBloc implements BlocBase {
  final AuthHandlerBase _authHandler = FirebaseProvider().getAuthHandler();

  final ConnectionHandlerBase _connectionHandler =
      SpotifyProvider().getConnectionHandler();

  final TokenHandlerBase _tokenHandler = SpotifyProvider().getTokenHandler();

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

  /// A [BehaviorSubject] that broadcasts the current auth url.
  final BehaviorSubject<String> _urlSubject = BehaviorSubject.seeded(null);

  ValueObservable<String> get urlStream => _urlSubject.stream;

  SessionStateBloc() {
    _stateSub = _stateSubject.listen((SessionState state) {
      switch (state) {
        case SessionState.REJOINING:
          _rejoinSession();
          break;
        case SessionState.LEAVING:
          _leaveSession();
          break;
        case SessionState.AWAITING_URL:
          _fetchURL();
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

  void createSession(TokenModel tokens) {
    if (_stateSubject.value == SessionState.AWAITING_CONNECTION) {
      _stateSubject.add(SessionState.AWAITING_CONNECTION);
      _createSession(tokens);
    }
  }

  /// A getter for the session ID.
  String sid({bool checked = false}) => _stateHandler.sid(checked: checked);

  /// Attempts to rejoin a session.
  void _rejoinSession() async {
    _stateHandler.rejoinSession().then((bool joined) {
      _stateSubject.add(joined ? SessionState.ACTIVE : SessionState.CHOOSING);
    }).catchError((e) {
      _stateSubject.addError(e);
    });
  }

  /// Attempts to join a session with the given [sid].
  void _joinSession(String sid) async {
    _stateHandler.joinSession(sid).then((_) {
      _stateSubject.add(SessionState.ACTIVE);
    }).catchError((e) {
      _stateSubject.addError(e);
    });
  }

  /// Fetches the auth URL.
  void _fetchURL() {
    _tokenHandler.requestAuthUrl().then((String url) {
      _urlSubject.add(url);
      _stateSubject.add(SessionState.AWAITING_TOKENS);
    }).catchError((e) {
      _stateSubject.addError(e);
    });
  }

  /// Attempts to create a session.
  void _createSession(TokenModel tokens) async {
    UserModel user = UserModel.empty(await _authHandler.uid());
    final sid = await _generateSID();
    SessionModel model = SessionModel.empty(sid, user, tokens);
    _stateHandler.createSession(model).then((_) {
      _stateSubject.add(SessionState.CREATED);
    }).catchError((e) {
      _stateSubject.addError(e);
    });
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
    _stateHandler.leaveSession().then((_) {
      _stateSubject.add(SessionState.INACTIVE);
    }).catchError((e) {
      _stateSubject.addError(e);
      return;
    });
  }

  @override
  void dispose() {
    _stateSub.cancel();
    _stateSubject.close();
    _urlSubject.close();
  }
}
