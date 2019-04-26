import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
}) {
  // Get the theme to use for text.
  final TextTheme textTheme = Theme.of(context).textTheme;

  // Set the correct icon to use for the action button.
  actionIcon = actionIcon ?? Icon(Icons.music_note);

  // Find the artist to use to label this track.
  final ArtistModel mainArtist = track.artists.length > 0
      ? track.artists[0]
      : ArtistModel.fromMap(DEFAULT_ARTIST);

  // Get the image url of this track.
  final List<ImageModel> images = track.album?.images;
  final imageUrl = images == null || images.isEmpty ? null : images[0].url;

  // Set the correct image to use based on whether we received a valid url.
  Image image = imageUrl == null
      ? Image.memory(
          transparentImage,
          fit: BoxFit.fitWidth,
        )
      : Image.network(
          imageUrl,
          fit: BoxFit.fitWidth,
          color: Color.fromRGBO(0, 0, 0, 64),
          colorBlendMode: BlendMode.darken,
        );

  return Card(
    elevation: 5,
    margin: margin,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    ),
    child: Container(
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          Container(
            width: width,
            height: height,
            child: image,
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
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
                  ),
                ),
                IconButton(
                  icon: actionIcon,
                  onPressed: onAction,
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
