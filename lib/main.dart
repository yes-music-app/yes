import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yes_music/methods/connection_handler_base.dart';
import 'package:yes_music/methods/spotify/spotify_connection_handler.dart';
import 'package:yes_music/methods/spotify/spotify_playback_handler.dart';
import 'package:yes_music/models/player_state_model.dart';

void main() => runApp(MyApp());

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
      : this.connectionSubject =
            new SpotifyConnectionHandler().connectionSubject,
        this.stateSubject = new SpotifyPlaybackHandler().playerStateSubject,
        super(key: key);

  final BehaviorSubject<CONNECTION_STATE> connectionSubject;
  final BehaviorSubject<PlayerStateModel> stateSubject;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    widget.connectionSubject.listen((state) {
      if (state == CONNECTION_STATE.CONNECTED) {
        new SpotifyPlaybackHandler().subscribeToPlayerState();
      } else if (state == CONNECTION_STATE.DISCONNECTED) {
        new SpotifyPlaybackHandler().unsubscribeFromPlayerState();
      }
    });

    super.initState();
  }

  void _connect() {
    CONNECTION_STATE state = widget.connectionSubject.value;
    switch (state) {
      case CONNECTION_STATE.CONNECTED:
        new SpotifyConnectionHandler().disconnect();
        break;
      case CONNECTION_STATE.DISCONNECTED:
        new SpotifyConnectionHandler().connect();
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
              stream: widget.connectionSubject,
              builder: (context, snapShot) {
                String text = "";

                if (snapShot == null || !snapShot.hasData) {
                  text = "no snapshot";
                } else {
                  switch (snapShot.data) {
                    case CONNECTION_STATE.CONNECTED:
                      text = "connected";
                      break;
                    case CONNECTION_STATE.CONNECTING:
                      text = "connecting";
                      break;
                    case CONNECTION_STATE.DISCONNECTED:
                      text = "disconnected";
                      break;
                  }
                }
                return Text(
                  text,
                );
              },
            ),
            StreamBuilder(
              stream: widget.stateSubject,
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
