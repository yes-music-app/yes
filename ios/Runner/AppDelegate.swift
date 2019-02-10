import UIKit
import Flutter

@UIApplicationMain
class AppDelegate: UIResponder,
UIApplicationDelegate, SPTAppRemoteDelegate {
    
    fileprivate let redirectUri = URL(string:"comspotifytestsdk://")!
    fileprivate let clientIdentifier = "089d841ccc194c10a77afad9e1c11d54"
    fileprivate let name = "Now Playing View"
    
    // keys
    static fileprivate let kAccessTokenKey = "access-token-key"
    
    var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: AppDelegate.kAccessTokenKey)
            defaults.synchronize()
        }
    }
    
    
    var playerViewController: ViewController {
        get {
            let navController = self.window?.rootViewController?.childViewControllers[0] as! UINavigationController
            return navController.topViewController as! ViewController
        }
    }
    
    var window: UIWindow?
    
    lazy var appRemote: SPTAppRemote = {
        let configuration = SPTConfiguration(clientID: self.clientIdentifier, redirectURL: self.redirectUri)
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    class var sharedInstance: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let parameters = appRemote.authorizationParameters(from: url);
        
        if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = access_token
            self.accessToken = access_token
        } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
            playerViewController.showError(error_description);
        }
        
        return true
    }
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
      ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let spotifyChannel = FlutterMethodChannel(name: "yes.yesmusic/spotify",
                                                  binaryMessenger: controller)
    
    
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }
    
    func applicationWillResignActive(_ application: UIApplication) {
        playerViewController.appRemoteDisconnect()
        appRemote.disconnect()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.connect();
    }
    
    func connect() {
        playerViewController.appRemoteConnecting()
        appRemote.connect()
    }
    
    // MARK: AppRemoteDelegate
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote = appRemote
        playerViewController.appRemoteConnected()
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("didFailConnectionAttemptWithError")
        playerViewController.appRemoteDisconnect()
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("didDisconnectWithError")
        playerViewController.appRemoteDisconnect()
    }
    
}
//
//@UIApplicationMain
//@objc class AppDelegate: FlutterAppDelegate, UIResponder {
//    let SpotifyClientID = "[your spotify client id here]"
//    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
//
//  override func application(
//    _ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
//  ) -> Bool {
//    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
//    let spotifyChannel = FlutterMethodChannel(name: "yes.yesmusic/spotify",
//                                              binaryMessenger: controller)
//
//
//    GeneratedPluginRegistrant.register(with: self)
//    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//  }
//
//
//}
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
