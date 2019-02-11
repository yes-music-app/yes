//
//  PlaybackChannelHandler.swift
//  Runner
//
//  Created by Evan Hiroshige on 2/10/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

class SpotifyPlaybackHandler: NSObject, SPTAppRemoteUserAPIDelegate{

    
    let playbackChannel: FlutterMethodChannel
    let appRemote: SPTAppRemote
    
    init(playbackChannel: FlutterMethodChannel, appRemote: SPTAppRemote) {
        self.playbackChannel = playbackChannel
        self.appRemote = appRemote
        
        playbackChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch (call.method) {
            case "subscribeToPlayerState":
                self.subscribeToPlayerState(result: result)
                break
            case "unsubscribeFromPlayerState":
                self.unsubscribeFromPlayerState(result: result)
                break
            default:
                break
            }
        })
    }
    
    private func subscribeToPlayerState(result: @escaping FlutterResult) {
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                result(error)
            } else if let success = success {
                result(success)
            }
        })
    }
    
    private func unsubscribeFromPlayerState(result: @escaping FlutterResult) {
        appRemote.playerAPI?.unsubscribe(toPlayerState: { (success, error) in
            if let error = error {
                result(error)
            } else if let success = success {
                result(success)
            }
        })
    }
    
    func userAPI(_ userAPI: SPTAppRemoteUserAPI, didReceive capabilities: SPTAppRemoteUserCapabilities) {
    
    }
}
