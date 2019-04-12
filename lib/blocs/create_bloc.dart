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

/// An enumeration of the potential states that a create operation can be in.
enum CreateSessionState {
  NOT_CREATED,
  CREATING,
  CREATED,
}

/// A bloc that handles creating a session.
class CreateBloc implements BlocBase {
  /// The [AuthHandlerBase] reference to retrieve the uid.
  final AuthHandlerBase _authHandler = FirebaseProvider().getAuthHandler();

  /// The [SessionStateHandlerBase] that performs the create operation.
  final SessionStateHandlerBase _stateHandler =
      FirebaseProvider().getSessionStateHandler();

  /// The [BehaviorSubject] that broadcasts the current state of the user's
  /// attempt to create a session.
  BehaviorSubject<CreateSessionState> _createState =
      BehaviorSubject.seeded(CreateSessionState.NOT_CREATED);

  ValueObservable<CreateSessionState> get stream => _createState.stream;

  StreamSink<CreateSessionState> get sink => _createState.sink;

  /// A subscription to the create state.
  StreamSubscription<CreateSessionState> _sub;

  /// A getter for the session sid.
  String get sid => _stateHandler.sid(checked: false);

  CreateBloc() {
    // Create a subscription to the state stream.
    _sub = _createState.listen((CreateSessionState state) {
      switch (state) {
        case CreateSessionState.CREATING:
          // If the UI tells us to create a session, begin to create one.
          _createSession();
          break;
        default:
          break;
      }
    });
  }

  /// Attempts to create a new session.
  void _createSession() async {
    String uid = await _authHandler.uid();
    String newSid = await _generateSID();
    UserModel user = UserModel(uid, SearchModel.empty());
    SessionModel model = SessionModel.empty(newSid, user);

    // Create a new session.
    _stateHandler.createSession(model).then((_) {
      // When the new session is created, push the created state.
      _createState.add(CreateSessionState.CREATED);
    }).catchError((e) {
      // If an error occurs, push it to the state stream.
      _createState.addError(e);
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

  @override
  void dispose() {
    _sub.cancel();
    _createState.close();
  }
}
