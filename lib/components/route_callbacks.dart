import 'package:flutter/material.dart';
import 'package:yes_music/blocs/search_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/login/login_screen.dart';
import 'package:yes_music/components/main/main_screen.dart';
import 'package:yes_music/components/main/search_screen.dart';
import 'package:yes_music/components/setup/choose_screen.dart';
import 'package:yes_music/components/setup/create_screen.dart';
import 'package:yes_music/components/setup/join_screen.dart';
import 'package:yes_music/components/setup/rejoin_screen.dart';

typedef RouteCallback = Widget Function(BuildContext context);

final RouteCallback loginCallback = (context) => LoginScreen();

final RouteCallback rejoinCallback = (context) => RejoinScreen();

final RouteCallback chooseCallback = (context) => ChooseScreen();

final RouteCallback createCallback = (context) => CreateScreen();

final RouteCallback joinCallback = (context) => JoinScreen();

final RouteCallback mainCallback = (context) => MainScreen();

MaterialPageRoute searchCallback(String accessToken) => MaterialPageRoute(
      builder: (BuildContext context) => BlocProvider(
            bloc: SearchBloc(accessToken),
            child: SearchScreen(),
          ),
      maintainState: false,
    );
