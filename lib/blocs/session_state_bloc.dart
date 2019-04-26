import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/auth_handler_base.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/session_state_handler_base.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';
import 'package:yes_music/data/spotify/spotify_provider.dart';
import 'package:yes_music/helpers/data_utils.dart';
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
  CREATING,
  CREATED,
  ACTIVE,
  SEARCHING,
  LEAVING,
}

/// A bloc that handles managing session state.
class SessionStateBloc implements BlocBase {
  final AuthHandlerBase _authHandler = FirebaseProvider().getAuthHandler();

  final ConnectionHandlerBase _connectionHandler =
      SpotifyProvider().getConnectionHandler();

  /// A reference to the session handler.
  final SessionStateHandlerBase _stateHandler =
      FirebaseProvider().getSessionStateHandler();

  /// A [BehaviorSubject] that broadcasts the current state of the session.
  final BehaviorSubject<SessionState> _stateSubject =
      BehaviorSubject.seeded(SessionState.INACTIVE);

  ValueObservable<SessionState> get stateStream => _stateSubject.stream;

  StreamSink<SessionState> get stateSink => _stateSubject.sink;

  StreamSubscription<SessionState> _stateSub;

  /// A [StreamController] that broadcasts the current auth url.
  final StreamController<String> _urlSubject =
      StreamController<String>.broadcast();

  Stream<String> get urlStream => _urlSubject.stream;

  /// A [StreamController] that receives the latest [TokenModel].
  final StreamController<String> _codeSubject =
      StreamController<String>.broadcast();

  StreamSink<String> get codeSink => _codeSubject.sink;

  /// A [StreamController] that receives the latest sid to join.
  final StreamController<String> _sidSubject =
      StreamController<String>.broadcast();

  StreamSink<String> get sidSink => _sidSubject.sink;

  StreamSubscription _sidSub;

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
        case SessionState.AWAITING_TOKENS:
          _codeSubject.stream.first.then((String code) {
            stateSink.add(SessionState.CREATING);
            _createSession(code);
          });
          break;
        default:
          break;
      }
    });

    _sidSub = _sidSubject.stream.listen(_joinSession);
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
    if (_stateSubject.value != SessionState.JOINING) {
      _stateSubject.addError(StateError("errors.order"));
      return;
    }

    _stateHandler.joinSession(sid).then((_) {
      _stateSubject.add(SessionState.ACTIVE);
    }).catchError((e) {
      _stateSubject.addError(e);
    });
  }

  /// Fetches the auth URL.
  void _fetchURL() {
    if (_stateSubject.value != SessionState.AWAITING_URL) {
      _stateSubject.addError(StateError("errors.order"));
      return;
    }

    _connectionHandler.requestAuthUrl().then((String url) {
      _urlSubject.add(url);
    }).catchError((e) {
      _stateSubject.addError(e);
    });
  }

  /// Attempts to create a session.
  void _createSession(String code) async {
    try {
      // Generate the tokens from the given code.
      final Map data = await _connectionHandler.requestAccessToken(code);
      final TokenModel tokenModel = generateModel(data);

      // Connect to the Spotify app.
      await _connectionHandler.connect();

      // Generate the models needed to create a new session.
      final UserModel user = UserModel.empty(await _authHandler.uid());
      final sid = await generateSID();
      final SessionModel model = SessionModel.empty(sid, user, tokenModel);

      // Create the new session.
      await _stateHandler.createSession(model);
      _stateSubject.add(SessionState.CREATED);
    } catch (e) {
      // If any of the operations threw an error, push it through the stream.
      _stateSubject.addError(e);
    }
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
    _stateSub?.cancel();
    _stateSubject?.close();
    _urlSubject?.close();
    _codeSubject?.close();
    _sidSub?.cancel();
    _sidSubject?.close();
  }
}
