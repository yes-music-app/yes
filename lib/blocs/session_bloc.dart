import 'dart:typed_data';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/spotify/playback_handler_base.dart';
import 'package:yes_music/data/spotify/spotify_provider.dart';
import 'package:yes_music/models/spotify/player_state_model.dart';

/// A bloc that handles managing a session.
class SessionBloc implements BlocBase {
  /// The [PlaybackHandlerBase] that performs playback operations.
  final PlaybackHandlerBase _playbackHandler =
      SpotifyProvider().getPlaybackHandler();

  /// The previous [PlayerStateModel], used for determining whether to push new
  /// information through the visible streams.
  PlayerStateModel prevState;

  /// A [BehaviorSubject] that broadcasts changes in the image for the currently
  /// playing song.
  final BehaviorSubject<Uint8List> _imageSubject = BehaviorSubject(
    seedValue: null,
  );

  SessionBloc() {
    _playbackHandler.playerState.listen((PlayerStateModel model) {
      // If there were no changes to the player state, do not send out updates.
      if (model == prevState) {
        return;
      }

      // Set the previous state to the new model for future comparisons.
      prevState = model;
    });
  }

  @override
  void dispose() {
    _imageSubject.close();
  }
}
