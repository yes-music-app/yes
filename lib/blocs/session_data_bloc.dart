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

enum SessionConnectionState {
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
}

/// A bloc that handles operations on a session's data.
class SessionDataBloc implements BlocBase {
  /// A reference to the session data handler to use for network operations.
  final SessionDataHandlerBase _dataHandler =
      FirebaseProvider().getSessionDataHandler();

  /// A reference to the auth handler for network operations.
  final AuthHandlerBase _authHandler = FirebaseProvider().getAuthHandler();

  /// The session ID of this session.
  final String _sid;

  // <editor-fold desc="Streams">

  /// A subscription to the session state.
  StreamSubscription _sessionSub;

  /// An internal [BehaviorSubject] that broadcasts the data in the session.
  final BehaviorSubject<SessionModel> _modelSubject = BehaviorSubject();

  /// A [BehaviorSubject] that broadcasts the state of the model.
  final BehaviorSubject<SessionConnectionState> _connectionSubject =
      BehaviorSubject.seeded(SessionConnectionState.CONNECTING);

  ValueObservable<SessionConnectionState> get connectionStream =>
      _connectionSubject.stream;

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

  // </editor-fold>

  /// Creates a session data bloc.
  SessionDataBloc(this._sid) {
    _dataHandler.getSessionModelStream(_sid).then((Stream stream) {
      _sessionSub = stream.listen((data) {
        // Indicate if we have gained or lost connection with the session.
        if (data == null) {
          if (_connectionSubject.value == SessionConnectionState.CONNECTED) {
            _connectionSubject.add(SessionConnectionState.DISCONNECTED);
          }
          return;
        } else if (_connectionSubject.value ==
            SessionConnectionState.CONNECTING) {
          _connectionSubject.add(SessionConnectionState.CONNECTED);
        }

        // Generate a session model from the passed data.
        SessionModel model = SessionModel.fromMap(data);

        // Push the new model.
        if (model != _modelSubject.value) {
          _modelSubject.add(model);
        }

        // If we receive new data, push it.
        if (model.tokens.accessToken != _tokenSubject.value) {
          _tokenSubject.add(model.tokens.accessToken);
        }

        if (!listsEqual(model.queue, _queueListSubject.value)) {
          _queueListSubject.add(model.queue);
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

  /// Likes the track at the given qid.
  void _likeTrack(String qid) async {
    String uid = await _authHandler.uid(checked: true);
    _dataHandler.likeTrack(_sid, qid, uid);
  }

  /// Deletes the track at the given qid.
  void _deleteTrack(String qid) async {
    String uid = await _authHandler.uid(checked: true);

    // TODO: Check on a setting, either host or one who suggests the song.
    String songUid = _modelSubject.value.queue[qid]?.uid;
  }

  @override
  void dispose() {
    _modelSubject?.close();
    _sessionSub?.cancel();
    _connectionSubject.close();
    _tokenSubject.close();
    _queueListSubject.close();
    _queueSub?.cancel();
    _queueSubject.close();
    _likeSub?.cancel();
    _likeSubject.close();
  }
}
