import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      child: Scaffold(
        body: new CustomScrollView(
          slivers: <Widget>[
            _getAppBar(width),
            _getQueue(),
          ],
        ),
        floatingActionButton: _getAddButton(),
      ),
      onWillPop: () => Future.value(false),
    );
  }

  SliverAppBar _getAppBar(double width) {
    return new SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: 10,
      expandedHeight: width * (2 / 3),
      pinned: true,
      flexibleSpace: new FlexibleSpaceBar(
        centerTitle: true,
      ),
    );
  }

  SliverList _getQueue() {
    return new SliverList(
      delegate: _queueDelegate(),
    );
  }

  SliverChildBuilderDelegate _queueDelegate() {
    return new SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return new Container(
          padding: const EdgeInsets.all(10),
          child: new Text("hello world"),
        );
      },
      childCount: 50,
    );
  }

  Widget _getAddButton() {
    return new FloatingActionButton(
      child: new Icon(Icons.add),
      onPressed: () => {},
    );
  }
}
