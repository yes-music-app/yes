//
//  SpotifyDataMappers.swift
//  Runner
//
//  Created by Evan Hiroshige on 2/10/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

class SpotifyDataMappers {
    static func mapArtists(_ artists: Array<SPTAppRemoteArtist>) -> NSArray {
        let artistList = NSMutableArray.init()
        for artist in artists {
            artistList.add(mapArtist(artist))
        }
        return artistList
    }
    
    static func mapTrack(_ track: SPTAppRemoteTrack) -> NSDictionary {
       let trackMap = NSMutableDictionary.init()
        
        trackMap["album"] = mapAlbum(track.album)
        trackMap["artist"] = mapArtist(track.artist)
        trackMap["artists"] = mapArtist(track.artist)
        trackMap["duration"] = track.duration
        
        trackMap["imageUri"] =  track.uri
        trackMap["isEpisode"] =  track.isEpisode
        trackMap["isPodcast"] = track.isPodcast
        trackMap["name"] = track.name
        trackMap["uri"] = track.uri
        
        return trackMap
    }
    
    static func mapAlbum(_ album: SPTAppRemoteAlbum) -> NSDictionary {
        let albumMap = NSMutableDictionary.init()
        
        albumMap["name"] = album.name
        albumMap["uri"] =  album.uri
        
        return albumMap
    }
    
    static func mapArtist(_ artist: SPTAppRemoteArtist) -> NSDictionary{
        let artistMap = NSMutableDictionary.init()
    
        artistMap["name"] = artist.name
        artistMap["uri"] = artist.uri
    
    return artistMap;
    }
    
    static func mapPlayerState(_ playerState: SPTAppRemotePlayerState) -> NSDictionary {
        let stateMap = NSMutableDictionary.init()
    
        stateMap["isPaused"] = playerState.isPaused
    stateMap["playbackOptions"] = mapPlayerOptions(playerState.playbackOptions)
    stateMap["playbackPosition"] = playerState.playbackPosition
        stateMap["playbackRestrictions"] = mapPlayerRestrictions(playerState.playbackRestrictions)
    stateMap["playbackSpeed"] = playerState.playbackSpeed
    stateMap["track"] = mapTrack(playerState.track)
    
    return stateMap
    }
    
    static func mapPlayerOptions(_ playbackOptions: SPTAppRemotePlaybackOptions) -> NSDictionary {
        let optionsMap = NSMutableDictionary.init()
    
    optionsMap["isShuffling"] = playbackOptions.isShuffling
    optionsMap["repeatMode"] = playbackOptions.repeatMode
    
    return optionsMap;
    }
    
    static func mapPlayerRestrictions(_ restrictions: SPTAppRemotePlaybackRestrictions) -> NSDictionary {
    let restrictionsMap = NSMutableDictionary.init()
    
    restrictionsMap["canRepeatContext"] = restrictions.canRepeatContext
    restrictionsMap["canRepeatTrack"] = restrictions.canRepeatTrack
    restrictionsMap["canSeek"] = restrictions.canSeek
    restrictionsMap["canSkipNext"] = restrictions.canSkipNext
    restrictionsMap["canSkipPrev"] = restrictions.canSkipPrevious
    restrictionsMap["canToggleShuffle"] = restrictions.canToggleShuffle
    
    return restrictionsMap
    }
}
