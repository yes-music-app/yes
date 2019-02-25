import 'package:flutter/material.dart';
import 'package:yes_music/blocs/app_remote_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/blocs/create_bloc.dart';
import 'package:yes_music/blocs/firebase_connect_bloc.dart';
import 'package:yes_music/blocs/join_bloc.dart';
import 'package:yes_music/components/login/login_screen.dart';
import 'package:yes_music/components/setup/app_remote_screen.dart';
import 'package:yes_music/components/setup/create_screen.dart';
import 'package:yes_music/components/setup/join_screen.dart';

typedef RouteCallback = Widget Function(BuildContext context);

final RouteCallback loginCallback = (context) => new BlocProvider(
      bloc: new FirebaseConnectBloc(),
      child: new LoginScreen(),
    );

final RouteCallback appRemoteCallback = (context) => new BlocProvider(
      bloc: new AppRemoteBloc(),
      child: new AppRemoteScreen(),
    );

final RouteCallback createCallback = (context) => new BlocProvider(
      bloc: new CreateBloc(),
      child: new CreateScreen(),
    );

final RouteCallback joinCallback = (context) => new BlocProvider(
      bloc: new JoinBloc(),
      child: new JoinScreen(),
    );
