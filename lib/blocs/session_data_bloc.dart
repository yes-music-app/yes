import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/session_data_handler_base.dart';
import 'package:yes_music/models/state/session_model.dart';

/// A bloc that handles operations on a session's data.
class SessionDataBloc implements BlocBase {
  /// A reference to the session data handler to use for network operations.
  final SessionDataHandlerBase _dataHandler =
      FirebaseProvider().getSessionDataHandler();

  /// A subscription to the session model stream.
  StreamSubscription _sessionSub;

  /// A [BehaviorSubject] that broadcasts the current access token.
  final BehaviorSubject<String> _tokenSubject = BehaviorSubject();

  ValueObservable<String> get tokenStream => _tokenSubject.stream;

  /// Creates a session data bloc with the given [sid].
  SessionDataBloc(String sid) {
    _dataHandler.getSessionModelStream(sid).then((Stream<SessionModel> stream) {
      stream.listen((SessionModel data) {
        // If we receive a new access token, push it.
        if (data.tokens.accessToken != _tokenSubject.value) {
          _tokenSubject.add(data.tokens.accessToken);
        }
      });
    });
  }

  @override
  void dispose() {
    _sessionSub?.cancel();
    _tokenSubject.close();
  }
}
