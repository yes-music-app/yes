import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/session_data_bloc.dart';
import 'package:yes_music/components/common/track_card.dart';
import 'package:yes_music/models/state/song_model.dart';

const double CARD_HEIGHT = 60;

/// A class that represents a queue item. This wrapper class allows us to sort
/// the items in the queue without losing the original order.
class QueueModel {
  /// The song item that this model represents.
  final SongModel song;

  /// The original index of the song in the queue.
  final int originalIndex;

  /// Creates a new queue item with the given song and index.
  QueueModel(this.song, this.originalIndex);
}

/// Builds a list of track cards to display in the queue.
Widget queueBuilder(
  BuildContext context,
  AsyncSnapshot<List<SongModel>> snapshot,
  String uid,
  SessionDataBloc dataBloc,
) {
  if (snapshot == null || !snapshot.hasData || snapshot.hasError) {
    return _getLoadingStatus();
  }

  if (snapshot.data.isEmpty) {
    // If there are no tracks, indicate that to the user.
    return _getEmptyQueueStatus(context);
  }

  // Get a reference to the queued tracks.
  List<QueueModel> tracks = [];
  for (int i = 0; i < snapshot.data.length; i++) {
    tracks.add(QueueModel(snapshot.data[i], i));
  }

  // Sort by upvotes.
  tracks.sort((QueueModel a, QueueModel b) =>
      b.song.upvotes.length - a.song.upvotes.length);

  return SliverFixedExtentList(
    itemExtent: CARD_HEIGHT,
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        SongModel song = tracks[index].song;
        return trackCard(
          song.track,
          context,
          actionIcon: _getCardActionIcon(song, uid),
          onAction: () => dataBloc.likeSink.add(tracks[index].originalIndex),
        );
      },
      childCount: tracks.length,
    ),
  );
}

/// Gets the appropriate card action icon from the given [uid] and [song].
Icon _getCardActionIcon(SongModel song, String uid) =>
    Icon(song.upvotes.contains(uid) ? Icons.favorite : Icons.favorite_border);

/// Gets a loading status indicator.
Widget _getLoadingStatus() {
  return SliverList(
    delegate: SliverChildListDelegate(
      <Widget>[
        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: 30),
          child: CircularProgressIndicator(),
        ),
      ],
    ),
  );
}

/// Gets a status message telling the user that the queue is empty.
Widget _getEmptyQueueStatus(BuildContext context) {
  return SliverList(
    delegate: SliverChildListDelegate(
      <Widget>[
        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: 30),
          child: Text(
            FlutterI18n.translate(context, "main.queueEmpty"),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    ),
  );
}