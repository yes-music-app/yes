//
//  SpotifyConnectionHandler.swift
//  Runner
//
//  Created by Evan Hiroshige on 2/10/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

class SpotifyConnectionHandler: NSObject, SPTSessionManagerDelegate, SPTAppRemoteDelegate {
    let connectionChannel: FlutterMethodChannel
    fileprivate let SpotifyClientID = "a50706c333cb40a396c6020d9c79fb8b"
    fileprivate let SpotifyRedirectURI = URL(string: "yes-music-app://connect")!
    
    lazy var configuration = SPTConfiguration(
    clientID: SpotifyClientID,
    redirectURL: SpotifyRedirectURI
    )
    
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
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            switch (call.method) {
            case "connect":
                self.connect(result: result)
                break
            case "disconnect":
                self.disconnect(result: result)
            default:
                break
            }
        })
        
    }
    
    // MARK: - Flutter
    
    private func connect(result: FlutterResult) {
        let requestedScopes: SPTScope = [.appRemoteControl]
        if #available(iOS 11.0, *) {
            self.sessionManager.initiateSession(with: requestedScopes, options: .default)
        } else {
//            self.sessionManager.initiateSession(with: requestedScopes, options: .default, presenting: nil)
        }
    }
    
    private func disconnect(result: FlutterResult) {
        appRemote.disconnect()
    }
    
    private func updatePlayerState() {
       // self.connectionChannel.invokeMethod("updatePlayerState", arguments: SpotifyDataMappers.mapPlayerState())
    }
    
    
    // MARK: - SPTSessionManagerDelegate
 
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("error connecting" + error.localizedDescription)
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("renewed session")
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
    func sessionManager(manager: SPTSessionManager, shouldRequestAccessTokenWith code: String) -> Bool {
        return true
    }
    
    // MARK: - SPTAppRemoteDelegate
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        connectionChannel.invokeMethod("connectionUpdate", arguments: 2)
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
            }
        })
        
        
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
       
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {

    }
}
