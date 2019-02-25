import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yes_music/blocs/login_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/main/main_screen.dart';
import 'package:yes_music/components/route_callbacks.dart';
import 'package:yes_music/components/setup/choose_screen.dart';
import 'package:yes_music/components/setup/spotify_auth_screen.dart';
import 'package:yes_music/components/themes.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/flavor.dart';
import 'package:yes_music/data/spotify/spotify_provider.dart';

void main() async {
  FirebaseProvider().setFlavor(Flavor.REMOTE);
  SpotifyProvider().setFlavor(Flavor.REMOTE);
  await Firestore.instance.settings(timestampsInSnapshotsEnabled: true);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(YesApp()));
}

class YesApp extends StatelessWidget {
  final Map<String, RouteCallback> _routes = {
    "/": loginCallback,
    "/choose": (context) => ChooseScreen(),
    "/spotifyAuth": (context) => SpotifyAuthScreen(),
    "/appRemote": appRemoteCallback,
    "/create": createCallback,
    "/join": joinCallback,
    "/main": (context) => MainScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      bloc: LoginBloc(),
      child: MaterialApp(
        title: "yes",
        theme: Themes.darkTheme,
        initialRoute: "/",
        routes: _routes,
        localizationsDelegates: [
          FlutterI18nDelegate(false, "en", "assets/locales"),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}
