import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/auth_handler_base.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/session_data_handler_base.dart';
import 'package:yes_music/helpers/list_utils.dart';
import 'package:yes_music/models/spotify/track_model.dart';
import 'package:yes_music/models/state/session_model.dart';
import 'package:yes_music/models/state/song_model.dart';

/// A bloc that handles operations on a session's data.
class SessionDataBloc implements BlocBase {
  /// A reference to the session data handler to use for network operations.
  final SessionDataHandlerBase _dataHandler =
      FirebaseProvider().getSessionDataHandler();

  /// The session ID of this session.
  final String _sid;

  /// A reference to the auth handler for network operations.
  final AuthHandlerBase _authHandler = FirebaseProvider().getAuthHandler();

  /// A subscription to the session model stream.
  StreamSubscription _sessionSub;

  /// A [BehaviorSubject] that broadcasts the current access token.
  final BehaviorSubject<String> _tokenSubject = BehaviorSubject();

  ValueObservable<String> get tokenStream => _tokenSubject.stream;

  /// A [BehaviorSubject] that broadcasts the current state of the queue.
  final BehaviorSubject<List<SongModel>> _queueListSubject = BehaviorSubject();

  ValueObservable<List<SongModel>> get queueListStream =>
      _queueListSubject.stream;

  /// A [StreamController] that handles the queuing of new songs to play.
  final StreamController<TrackModel> _queueSubject =
      StreamController.broadcast();

  StreamSink<TrackModel> get queueSink => _queueSubject.sink;

  StreamSubscription _queueSub;

  /// A [StreamController] that handles the liking of items in the queue.
  final StreamController<String> _likeSubject = StreamController.broadcast();

  StreamSink<String> get likeSink => _likeSubject.sink;

  StreamSubscription _likeSub;

  /// Creates a session data bloc.
  SessionDataBloc(this._sid) {
    _dataHandler
        .getSessionModelStream(_sid)
        .then((Stream<SessionModel> stream) {
      _sessionSub = stream.listen((SessionModel data) {
        // If we receive new data, push it.
        if (data.tokens.accessToken != _tokenSubject.value) {
          _tokenSubject.add(data.tokens.accessToken);
        }

        if (!listsEqual(data.queue, _queueListSubject.value)) {
          _queueListSubject.add(data.queue);
        }
      });
    });

    // Listen for new tracks to queue.
    _queueSub = _queueSubject.stream.listen((TrackModel data) {
      if (data != null) {
        _queueTrack(data);
      }
    });

    // Listen for new items to like.
    _likeSub = _likeSubject.stream.listen(_likeTrack);
  }

  /// Queues the given track for the user.
  void _queueTrack(TrackModel track) async {
    String uid = await _authHandler.uid(checked: true);
    _dataHandler.queueTrack(_sid, uid, track);
  }

  void _likeTrack(String qid) async {
    String uid = await _authHandler.uid(checked: true);
    _dataHandler.likeTrack(_sid, qid, uid);
  }

  @override
  void dispose() {
    _sessionSub?.cancel();
    _tokenSubject.close();
    _queueListSubject.close();
    _queueSub?.cancel();
    _queueSubject.close();
    _likeSub?.cancel();
    _likeSubject.close();
  }
}
