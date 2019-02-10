package com.yes.yesmusic.methods.spotify;

import com.spotify.protocol.types.Album;
import com.spotify.protocol.types.Artist;
import com.spotify.protocol.types.PlayerOptions;
import com.spotify.protocol.types.PlayerRestrictions;
import com.spotify.protocol.types.PlayerState;
import com.spotify.protocol.types.Track;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class SpotifyDataMappers {

  private static ArrayList<HashMap<String, Object>> mapArtists(List<Artist> artists) {
    ArrayList<HashMap<String, Object>> artistList = new ArrayList<>();
    for (Artist artist : artists) {
      artistList.add(mapArtist(artist));
    }

    return artistList;
  }

  public static HashMap<String, Object> mapTrack(Track track) {
    HashMap<String, Object> trackMap = new HashMap<>();

    trackMap.put("album", mapAlbum(track.album));
    trackMap.put("artist", mapArtist(track.artist));
    trackMap.put("artists", mapArtists(track.artists));
    trackMap.put("duration", track.duration);
    trackMap.put("imageUri", track.imageUri.raw);
    trackMap.put("isEpisode", track.isEpisode);
    trackMap.put("isPodcast", track.isPodcast);
    trackMap.put("name", track.name);
    trackMap.put("uri", track.uri);

    return trackMap;
  }

  public static HashMap<String, Object> mapAlbum(Album album) {
    HashMap<String, Object> albumMap = new HashMap<>();

    albumMap.put("name", album.name);
    albumMap.put("uri", album.uri);

    return albumMap;
  }

  public static HashMap<String, Object> mapArtist(Artist artist) {
    HashMap<String, Object> artistMap = new HashMap<>();

    artistMap.put("name", artist.name);
    artistMap.put("uri", artist.uri);

    return artistMap;
  }

  public static HashMap<String, Object> mapPlayerState(PlayerState playerState) {
    HashMap<String, Object> stateMap = new HashMap<>();

    stateMap.put("isPaused", playerState.isPaused);
    stateMap.put("playbackOptions", mapPlayerOptions(playerState.playbackOptions));
    stateMap.put("playbackPosition", playerState.playbackPosition);
    stateMap.put("playbackRestrictions", mapPlayerRestrictions(playerState.playbackRestrictions));
    stateMap.put("playbackSpeed", playerState.playbackSpeed);
    stateMap.put("track", mapTrack(playerState.track));

    return stateMap;
  }

  public static HashMap<String, Object> mapPlayerOptions(PlayerOptions playerOptions) {
    HashMap<String, Object> optionsMap = new HashMap<>();

    optionsMap.put("isShuffling", playerOptions.isShuffling);
    optionsMap.put("repeatMode", playerOptions.repeatMode);

    return optionsMap;
  }

  public static HashMap<String, Object> mapPlayerRestrictions(PlayerRestrictions restrictions) {
    HashMap<String, Object> restrictionsMap = new HashMap<>();

    restrictionsMap.put("canRepeatContext", restrictions.canRepeatContext);
    restrictionsMap.put("canRepeatTrack", restrictions.canRepeatTrack);
    restrictionsMap.put("canSeek", restrictions.canSeek);
    restrictionsMap.put("canSkipNext", restrictions.canSkipNext);
    restrictionsMap.put("canSkipPrev", restrictions.canSkipPrev);
    restrictionsMap.put("canToggleShuffle", restrictions.canToggleShuffle);

    return restrictionsMap;
  }
}
