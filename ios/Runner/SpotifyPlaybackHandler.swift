//
//  PlaybackChannelHandler.swift
//  Runner
//
//  Created by Evan Hiroshige on 2/10/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

class SpotifyPlaybackHandler: NSObject, SPTAppRemotePlayerStateDelegate{

    
    let playbackChannel: FlutterMethodChannel
    let appRemote: SPTAppRemote
    
    init(playbackChannel: FlutterMethodChannel, appRemote: SPTAppRemote) {
        self.playbackChannel = playbackChannel
        self.appRemote = appRemote
        super.init()
        
        self.appRemote.playerAPI?.delegate = self
        
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
                result(error.localizedDescription)
                print(error.localizedDescription)
                print(error.localizedDescription)
            } else if let success = success {
                result(success)
                print(success)
            }
        })
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("1")
    }
}
