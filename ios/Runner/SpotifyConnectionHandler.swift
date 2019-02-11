//
//  SpotifyConnectionHandler.swift
//  Runner
//
//  Created by Evan Hiroshige on 2/10/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

class SpotifyConnectionHandler: NSObject, SPTSessionManagerDelegate, SPTAppRemoteDelegate {
    let connectionChannel: FlutterMethodChannel
    fileprivate let SpotifyClientID = "044b2c45e77f45aca8da89e338849b6a"
    fileprivate let SpotifyRedirectURI = URL(string: "spotify-login-sdk-test-app://spotify-login-callback")!
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
        
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = ""
        
        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()
    
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    
    init(connectionChannel: FlutterMethodChannel) {
        self.connectionChannel = connectionChannel
        super.init()
        
        connectionChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            switch (call.method) {
            case "connect":
                self?.connect(result: result)
                break
            case "disconnect":
                self?.disconnect(result: result)
            default:
                break
            }
        })
        
    }
    
    private func connect(result: FlutterResult) {
        appRemote.connect() 
    }
    
    private func disconnect(result: FlutterResult) {
        appRemote.disconnect()
    }
    
    private func updatePlayerState() {
        self.connectionChannel.invokeMethod("updatePlayerState", arguments: nil)
    }
    
    
    // MARK: - SPTSessionManagerDelegate
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
    
    // MARK: - SPTAppRemoteDelegate
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
            }
        })
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        return;
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {

    }
}
