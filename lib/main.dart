import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yes_music/blocs/login_bloc.dart';
import 'package:yes_music/blocs/session_state_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/route_callbacks.dart';
import 'package:yes_music/components/themes.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/flavor.dart';
import 'package:yes_music/data/spotify/spotify_provider.dart';

void main() async {
  FirebaseProvider().setFlavor(Flavor.REMOTE);
  SpotifyProvider().setFlavor(Flavor.REMOTE);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(YesApp()));
}

class YesApp extends StatelessWidget {
  final Map<String, RouteCallback> _routes = {
    "/": loginCallback,
    "/rejoin": rejoinCallback,
    "/choose": chooseCallback,
    "/create": createCallback,
    "/join": joinCallback,
    "/main": mainCallback,
  };

  @override
  Widget build(BuildContext context) {
    return _wrappedApp(
      MaterialApp(
        title: "yes",
        theme: Themes.darkTheme,
        initialRoute: "/",
        routes: _routes,
        onGenerateRoute: _generateRoute,
        localizationsDelegates: [
          FlutterI18nDelegate(
            useCountryCode: false,
            fallbackFile: "en",
            path: "assets/locales",
          ),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}

/// Generate a route from a push named (used to allow for arguments).
Route _generateRoute(RouteSettings settings) {
  final args = settings.arguments;
  switch (settings.name) {
    case "/search":
      return args is String ? searchCallback(args) : null;
    default:
      return null;
  }
}

/// Wrap the given [child] widget in the global blocs.
Widget _wrappedApp(Widget child) {
  return BlocProvider<LoginBloc>(
    bloc: LoginBloc(),
    child: BlocProvider<SessionStateBloc>(
      bloc: SessionStateBloc(),
      child: child,
    ),
  );
}
