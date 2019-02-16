import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/blocs/firebase_connect_bloc.dart';
import 'package:yes_music/components/login/login_screen.dart';
import 'package:yes_music/components/themes.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/flavor.dart';
import 'package:yes_music/data/spotify/spotify_provider.dart';

void main() {
  new AuthProvider().setFlavor(Flavor.REMOTE);
  new SpotifyProvider().setFlavor(Flavor.REMOTE);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(YesApp()));
}

class YesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new BlocProvider<FirebaseConnectBloc>(
      bloc: new FirebaseConnectBloc(new AuthProvider().getAuthHandler()),
      child: new MaterialApp(
        title: "yes",
        theme: Themes.darkTheme,
        home: new LoginScreen(),
        localizationsDelegates: [
          FlutterI18nDelegate(false, "en", "assets/locales"),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}
