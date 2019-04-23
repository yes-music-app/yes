import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yes_music/models/spotify/artist_model.dart';
import 'package:yes_music/models/spotify/track_model.dart';

const Map DEFAULT_ARTIST = {
  NAME_KEY: "Unknown Artst",
  ARTIST_URI_KEY: "unknown_artist",
};

Widget trackCard(
  TrackModel track,
  BuildContext context, {
  double width = double.infinity,
  double height = 60,
  double borderRadius = 10,
  Color color,
  EdgeInsets margin =
      const EdgeInsets.only(left: 6, top: 6, right: 6, bottom: 0),
}) {
  final ArtistModel mainArtist = track.artists.length > 0
      ? track.artists[0]
      : ArtistModel.fromMap(DEFAULT_ARTIST);

  final String imageUrl = track.album.images[0].url;

  final TextTheme textTheme = Theme.of(context).textTheme;

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
            child: Image.network(
              imageUrl,
              fit: BoxFit.fitWidth,
              color: Color.fromRGBO(0, 0, 0, 64),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
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
                Icon(Icons.keyboard_arrow_up),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
