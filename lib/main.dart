import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/blocs/login_bloc.dart';
import 'package:yes_music/components/login/login_screen.dart';
import 'package:yes_music/components/themes.dart';
import 'package:yes_music/data/spotify/spotify_provider.dart';

void main() {
  new SpotifyProvider().setFlavor(Flavor.REMOTE);
  runApp(YesApp());
}

class YesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new BlocProvider<LoginBloc>(
      bloc: new LoginBloc(new SpotifyProvider().getConnectionHandler()),
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
