import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/auth_handler_base.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/session_data_handler_base.dart';
import 'package:yes_music/models/spotify/track_model.dart';
import 'package:yes_music/models/state/session_model.dart';
import 'package:yes_music/models/state/song_model.dart';

/// A bloc that handles operations on a session's data.
class SessionDataBloc implements BlocBase {
  /// A reference to the session data handler to use for network operations.
  final SessionDataHandlerBase _dataHandler =
      FirebaseProvider().getSessionDataHandler();

  /// A reference to the auth handler for network operations.
  final AuthHandlerBase _authHandler = FirebaseProvider().getAuthHandler();

  /// A subscription to the session model stream.
  StreamSubscription _sessionSub;

  /// A [BehaviorSubject] that broadcasts the current access token.
  final BehaviorSubject<String> _tokenSubject = BehaviorSubject();

  ValueObservable<String> get tokenStream => _tokenSubject.stream;

  /// A [StreamController] that handles the queuing of new songs to play.
  final StreamController<TrackModel> _queueSubject =
      StreamController.broadcast();

  StreamSink<TrackModel> get queueSink => _queueSubject.sink;

  StreamSubscription _queueSub;

  /// Creates a session data bloc with the given [sid].
  SessionDataBloc() {
    _dataHandler.getSessionModelStream().then((Stream<SessionModel> stream) {
      _sessionSub = stream.listen((SessionModel data) {
        // If we receive a new access token, push it.
        if (data.tokens.accessToken != _tokenSubject.value) {
          _tokenSubject.add(data.tokens.accessToken);
        }
      });
    });

    // Listen for new tracks to queue.
    _queueSub = _queueSubject.stream.listen((TrackModel data) {
      if (data != null) {
        _queueTrack(data);
      }
    });
  }

  /// Queues the given track for the user.
  void _queueTrack(TrackModel track) async {
    String uid = await _authHandler.uid(checked: true);
    SongModel model = SongModel(track, uid, [uid]);
    _dataHandler.queueTrack(model);
  }

  @override
  void dispose() {
    _sessionSub?.cancel();
    _tokenSubject.close();
    _queueSub?.cancel();
    _queueSubject.close();
  }
}
