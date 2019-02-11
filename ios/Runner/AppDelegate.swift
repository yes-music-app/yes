import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, SPTSessionManagerDelegate {
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        
    }
    
    let SpotifyClientID = "[your spotify client id here]"
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    var connectionChannel: FlutterMethodChannel!
    var playbackChannel: FlutterMethodChannel!
   
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        self.connectionChannel = FlutterMethodChannel(name: "yes.yesmusic/connection",
                                                  binaryMessenger: controller)
        self.playbackChannel = FlutterMethodChannel(name: "yes.yesmusic/playback",
                                                    binaryMessenger: controller)
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
        
        
        playbackChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
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
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    // MARK: SPTSessionManager
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )

    lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://[my token swap app domain]/api/token"),
            let tokenRefreshURL = URL(string: "https://[my token swap app domain]/api/refresh_token") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            self.configuration.playURI = ""
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()

//    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
//        self.appRemote.connectionParameters.accessToken = session.accessToken
//        self.appRemote.connect()
//        print("success", session)
//    }
//    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
//        print("fail", error)
//    }
//    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
//        print("renewed", session)
//    }

    override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        self.sessionManager.application(app, open: url, options: options)
        return true
    }
    // MARK: connectionChannel
    
    private func connect(result: FlutterResult) {
      // implement
    }
    
    private func disconnect(result: FlutterResult) {
        // implement
    }
    
    private func updatePlayerState() {
        self.connectionChannel.invokeMethod("updatePlayerState", arguments: nil)
    }
    
    // MARK: playbackChannel
    
    private func subscribeToPlayerState(result: FlutterResult) {
        
    }
    
    private func unsubscribeFromPlayerState(result: FlutterResult) {
        
    }
    
}
//
//extension AppDelegate: SPTSessionManagerDelegate {
//    lazy var configuration = SPTConfiguration(
//        clientID: SpotifyClientID,
//        redirectURL: SpotifyRedirectURL
//    )
//
//    lazy var sessionManager: SPTSessionManager = {
//        if let tokenSwapURL = URL(string: "https://[my token swap app domain]/api/token"),
//            let tokenRefreshURL = URL(string: "https://[my token swap app domain]/api/refresh_token") {
//            self.configuration.tokenSwapURL = tokenSwapURL
//            self.configuration.tokenRefreshURL = tokenRefreshURL
//            self.configuration.playURI = ""
//        }
//        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
//        return manager
//    }()
//
//    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
//        self.appRemote.connectionParameters.accessToken = session.accessToken
//        self.appRemote.connect()
//        print("success", session)
//    }
//    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
//        print("fail", error)
//    }
//    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
//        print("renewed", session)
//    }
//
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        self.sessionManager.application(app, open: url, options: options)
//        return true
//    }
//}
//
//extension AppDelegate: SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
//    lazy var appRemote: SPTAppRemote = {
//        let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
//        appRemote.delegate = self
//        return appRemote
//    }()
//    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
//        // Connection was successful, you can begin issuing commands
//        self.appRemote.playerAPI?.delegate = self
//        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
//            if let error = error {
//                debugPrint(error.localizedDescription)
//            }
//        })
//        print("connected")
//    }
//    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
//        print("disconnected")
//    }
//    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
//        print("failed")
//    }
//    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
//        debugPrint("Track name: %@", playerState.track.name)
//        print("player state changed")
//    }
//
//    func applicationWillResignActive(_ application: UIApplication) {
//        if self.appRemote.isConnected {
//            self.appRemote.disconnect()
//        }
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        if let _ = self.appRemote.connectionParameters.accessToken {
//            self.appRemote.connect()
//        }
//    }
//
//}
//
