import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';
import 'package:yes_music/data/spotify/playback_handler_base.dart';
import 'package:yes_music/data/spotify/spotify_provider.dart';
import 'package:yes_music/models/spotify/player_state_model.dart';

void main() {
  new SpotifyProvider().setFlavor(Flavor.REMOTE);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title})
      : this._playbackHandler = new SpotifyProvider().getPlaybackHandler(),
        this._connectionHandler = new SpotifyProvider().getConnectionHandler(),
        super(key: key);

  final PlaybackHandlerBase _playbackHandler;
  final ConnectionHandlerBase _connectionHandler;

  BehaviorSubject<PlayerStateModel> get _stateSubject =>
      _playbackHandler?.playerStateSubject;

  BehaviorSubject<SpotifyConnectionState> get _connectionSubject =>
      _connectionHandler?.connectionSubject;

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    widget._connectionSubject.listen((state) {
      if (state == SpotifyConnectionState.CONNECTED) {
        widget._playbackHandler.subscribeToPlayerState();
      }
    });

    super.initState();
  }

  void _connect() {
    SpotifyConnectionState state = widget._connectionSubject.value;
    switch (state) {
      case SpotifyConnectionState.CONNECTED:
        widget._connectionHandler.disconnect();
        break;
      case SpotifyConnectionState.DISCONNECTED:
        widget._connectionHandler.connect();
        break;
      case SpotifyConnectionState.FAILED:
        widget._connectionHandler.connect();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: widget._connectionSubject,
              builder: (context, snapShot) {
                String text = "";

                if (snapShot == null || !snapShot.hasData) {
                  text = "no snapshot";
                } else {
                  switch (snapShot.data) {
                    case SpotifyConnectionState.CONNECTED:
                      text = "connected";
                      break;
                    case SpotifyConnectionState.CONNECTING:
                      text = "connecting";
                      break;
                    case SpotifyConnectionState.DISCONNECTED:
                      text = "disconnected";
                      break;
                    case SpotifyConnectionState.FAILED:
                      text = "connection failed";
                      break;
                  }
                }
                return Text(
                  text,
                );
              },
            ),
            StreamBuilder(
              stream: widget._stateSubject,
              builder: (context, snapShot) {
                String text = "";

                if (snapShot == null ||
                    !snapShot.hasData ||
                    snapShot.data == null) {
                  return new Text("Nothing playing");
                } else {
                  text = snapShot.data.track.name;
                }
                return Text(
                  text,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _connect,
        tooltip: 'Connect',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
