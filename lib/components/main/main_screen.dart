import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yes_music/blocs/session_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/loading_indicator.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SessionBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<SessionBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            _getAppBar(width, Uint8List(0)),
            _getQueue(),
          ],
        ),
        floatingActionButton: _getAddButton(),
      ),
      onWillPop: () => Future.value(false),
    );
  }

  SliverAppBar _getAppBar(double width, Uint8List bytes) {
    return SliverAppBar(
      actions: _getAppBarActions(),
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 10,
      expandedHeight: width * (2 / 3),
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: _getAppBarImage(bytes),
      ),
      title: Text("Now playing"),
    );
  }

  List<Widget> _getAppBarActions() {
    return [
      PopupMenuButton(
        onSelected: (result) {},
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          
        ],
      ),
    ];
  }

  Widget _getAppBarImage(Uint8List bytes) {
    return bytes == null || bytes.isEmpty
        ? Center(
            child: loadingIndicator(),
          )
        : FittedBox(
            fit: BoxFit.fitWidth,
            child: Image.memory(bytes),
          );
  }

  SliverList _getQueue() {
    return SliverList(
      delegate: _queueDelegate(),
    );
  }

  SliverChildBuilderDelegate _queueDelegate() {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Text("hello world"),
        );
      },
      childCount: 50,
    );
  }

  Widget _getAddButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => {},
    );
  }
}
