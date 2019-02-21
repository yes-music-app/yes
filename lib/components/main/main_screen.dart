import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return new CustomScrollView(
      slivers: <Widget>[
        _getAppBar(width),
      ],
    );
  }

  SliverAppBar _getAppBar(double width) {
    return new SliverAppBar(
      expandedHeight: width * (2 / 3),
      flexibleSpace: new FlexibleSpaceBar(
        centerTitle: true,
      ),
    );
  }
}
