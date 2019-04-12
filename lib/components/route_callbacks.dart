import 'package:flutter/material.dart';
import 'package:yes_music/blocs/app_remote_bloc.dart';
import 'package:yes_music/blocs/create_bloc.dart';
import 'package:yes_music/blocs/join_bloc.dart';
import 'package:yes_music/blocs/rejoin_bloc.dart';
import 'package:yes_music/blocs/session_state_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/login/login_screen.dart';
import 'package:yes_music/components/main/main_screen.dart';
import 'package:yes_music/components/setup/app_remote_screen.dart';
import 'package:yes_music/components/setup/choose_screen.dart';
import 'package:yes_music/components/setup/create_screen.dart';
import 'package:yes_music/components/setup/join_screen.dart';
import 'package:yes_music/components/setup/rejoin_screen.dart';

typedef RouteCallback = Widget Function(BuildContext context);

final RouteCallback loginCallback = (context) => LoginScreen();

final RouteCallback rejoinCallback = (context) => BlocProvider(
      bloc: RejoinBloc(),
      child: RejoinScreen(),
    );

final RouteCallback chooseCallback = (context) => ChooseScreen();

final RouteCallback appRemoteCallback = (context) => BlocProvider(
      bloc: AppRemoteBloc(),
      child: AppRemoteScreen(),
    );

final RouteCallback createCallback = (context) => BlocProvider(
      bloc: CreateBloc(),
      child: CreateScreen(),
    );

final RouteCallback joinCallback = (context) => BlocProvider(
      bloc: JoinBloc(),
      child: JoinScreen(),
    );

final RouteCallback mainCallback = (context) => BlocProvider(
      bloc: SessionStateBloc(),
      child: MainScreen(),
    );
