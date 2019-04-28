import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yes_music/components/common/custom_dismissible.dart';
import 'package:yes_music/helpers/transparent_image.dart';
import 'package:yes_music/models/spotify/artist_model.dart';
import 'package:yes_music/models/spotify/image_model.dart';
import 'package:yes_music/models/spotify/track_model.dart';

/// The margin to be used between track cards.
const double TRACK_CARD_MARGIN = 6;

/// A default, empty artist for a track with no artist.
const Map DEFAULT_ARTIST = {
  NAME_KEY: "Unknown Artst",
  ARTIST_URI_KEY: "unknown_artist",
};

/// Creates a track card from the given [TrackModel].
Widget trackCard(
  TrackModel track,
  BuildContext context, {
  double width = double.infinity,
  double height = 60,
  double borderRadius = 10,
  Color color,
  EdgeInsets margin = const EdgeInsets.only(
    left: TRACK_CARD_MARGIN,
    top: TRACK_CARD_MARGIN,
    right: TRACK_CARD_MARGIN,
    bottom: 0,
  ),
  Icon actionIcon,
  VoidCallback onAction,
  VoidCallback onDelete,
}) {
  // Get the theme to use for text.
  final TextTheme textTheme = Theme
      .of(context)
      .textTheme;

  // Set the correct icon to use for the action button.
  actionIcon = actionIcon ?? Icon(Icons.music_note);

  // Get the image url of this track.
  final List<ImageModel> images = track.album?.images;
  final imageUrl = images
      ?.elementAt(0)
      ?.url;

  // Set the correct image to use based on whether we received a valid url.
  ImageProvider image =
  imageUrl == null ? MemoryImage(transparentImage) : NetworkImage(imageUrl);

  // The contents of the card.
  Widget contents = Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      image: DecorationImage(
        image: image,
        fit: BoxFit.fitWidth,
        colorFilter: ColorFilter.mode(
          Color.fromRGBO(0, 0, 0, 64),
          BlendMode.darken,
        ),
      ),
    ),
    child: _getContents(track, textTheme, actionIcon, onAction),
  );

  return Card(
    child: onDelete == null ? contents : _wrapCard(contents, onDelete),
    elevation: 5,
    margin: margin,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    ),
  );
}


/// Wraps the given widget in a [Dismissible] widget.
Widget _wrapCard(Widget child, VoidCallback onDelete) {
  return CustomDismissible(
    key: UniqueKey(),
    child: child,
    direction: DismissDirection.startToEnd,
    onDismissed: (DismissDirection direction) => onDelete(),
    background: Container(
      color: Colors.redAccent,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Icon(Icons.delete),
      ),
    ),
  );
}

/// Gets the contents of a track card that are to be laid over the image.
Widget _getContents(
  TrackModel track,
  TextTheme textTheme,
  Icon actionIcon,
  VoidCallback onAction,
) {
  return Container(
    margin: EdgeInsets.only(left: 20, right: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: _getTrackDetails(track, textTheme),
        ),
        IconButton(
          icon: actionIcon,
          onPressed: onAction,
        )
      ],
    ),
  );
}

/// Gets the widgets displaying the specific details of this track.
Widget _getTrackDetails(TrackModel track, TextTheme textTheme) {
  // Find the artist to use to label this track.
  final ArtistModel mainArtist = track.artists.length > 0
      ? track.artists[0]
      : ArtistModel.fromMap(DEFAULT_ARTIST);

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        track.name,
        overflow: TextOverflow.ellipsis,
        style: textTheme.body1,
      ),
      SizedBox(
        width: 0,
        height: 2,
      ),
      Text(
        mainArtist.name + " • " + track.album.name,
        overflow: TextOverflow.ellipsis,
        style: textTheme.caption,
      ),
    ],
  );
}
