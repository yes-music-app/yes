import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var connectionChannel: FlutterMethodChannel!
    private var playbackChannel: FlutterMethodChannel!
    private var playbackHandler: SpotifyPlaybackHandler!
    private var connectionHandler: SpotifyConnectionHandler!

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        self.connectionChannel = FlutterMethodChannel(name: "yes.yesmusic/connection",
                                                  binaryMessenger: controller)
        self.playbackChannel = FlutterMethodChannel(name: "yes.yesmusic/playback",
                                                    binaryMessenger: controller)
        
        self.connectionHandler = SpotifyConnectionHandler.init(connectionChannel: connectionChannel)
        self.playbackHandler = SpotifyPlaybackHandler.init(playbackChannel: playbackChannel, appRemote: connectionHandler.appRemote)
        

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        self.connectionHandler.sessionManager.application(app, open: url, options: options)
        
        return true
    }
   
    
    override func applicationWillResignActive(_ application: UIApplication) {
        if (connectionHandler.appRemote.isConnected) {
            connectionHandler.appRemote.disconnect()
        }
    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        if let _ = connectionHandler.appRemote.connectionParameters.accessToken {
            connectionHandler.appRemote.connect()
        }
    }
}
    

