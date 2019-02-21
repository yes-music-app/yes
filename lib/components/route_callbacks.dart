import 'package:flutter/material.dart';
import 'package:yes_music/blocs/app_remote_bloc.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/blocs/create_bloc.dart';
import 'package:yes_music/blocs/join_bloc.dart';
import 'package:yes_music/components/setup/app_remote_screen.dart';
import 'package:yes_music/components/setup/create_screen.dart';
import 'package:yes_music/components/setup/join_screen.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/spotify/spotify_provider.dart';

typedef RouteCallback = Widget Function(BuildContext context);

final RouteCallback appRemoteCallback = (context) => new BlocProvider(
      bloc: new AppRemoteBloc(new SpotifyProvider().getConnectionHandler()),
      child: new AppRemoteScreen(),
    );

final RouteCallback createCallback = (context) => new BlocProvider(
      bloc: new CreateBloc(new FirebaseProvider().getTransactionHandler()),
      child: new CreateScreen(),
    );

final RouteCallback joinCallback = (context) => new BlocProvider(
      bloc: new JoinBloc(),
      child: new JoinScreen(),
    );
