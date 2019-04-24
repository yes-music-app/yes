import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/search_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/track_card.dart';
import 'package:yes_music/models/spotify/track_model.dart';
import 'package:yes_music/models/state/search_model.dart';

/// A screen that allows the user to search for tracks to add.
class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

/// A class that represents the state of a [SearchScreen].
class _SearchScreenState extends State<SearchScreen> {
  /// The bloc that handles searching.
  SearchBloc _searchBloc;

  /// The text editing controller to use to control the query.
  final TextEditingController _controller = TextEditingController();
  String _oldText;

  /// Initialize the search bloc.
  @override
  void initState() {
    _searchBloc = BlocProvider.of<SearchBloc>(context);

    // Update the search bloc whenever the controller is changed.
    _controller.addListener(() {
      if (_oldText != _controller.text) {
        _searchBloc.querySink.add(_controller.text);
        _oldText = _controller.text;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: _getBody(),
    );
  }

  /// Gets the search app bar.
  Widget _getAppBar() {
    return AppBar(
      centerTitle: false,
      titleSpacing: 5,
      title: _getSearchBar(),
      actions: <Widget>[_getClearButton()],
    );
  }

  /// Gets the search bar to display in the app bar.
  Widget _getSearchBar() {
    return TextField(
      autocorrect: false,
      controller: _controller,
      decoration: InputDecoration.collapsed(
        hintText: FlutterI18n.translate(context, "main.searchHint"),
      ),
      style: Theme.of(context).textTheme.title,
    );
  }

  /// Gets the button to clear the text field.
  Widget _getClearButton() {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: _controller.clear,
    );
  }

  /// Gets the body elements to be displayed.
  Widget _getBody() {
    return StreamBuilder(
      stream: _searchBloc.searchStream,
      builder: (BuildContext context, AsyncSnapshot<SearchModel> snapshot) {
        // If we have not yet received a snapshot, show a loading indicator.
        if (snapshot == null) {
          return _getLoadingStatus();
        }

        // If we are waiting for a query, prompt the user to search.
        if (snapshot.data == null) {
          return _getNoResultsStatus();
        }

        // If the data is loading, show a loading indicator.
        if (snapshot.data.tracks == null) {
          return _getLoadingStatus();
        }

        // If the data is empty, tell the user that there are no results.
        if (snapshot.data.tracks.isEmpty) {
          return _getNoResultsStatus();
        }

        // If we have tracks to display, display them.
        return _getList(snapshot.data.tracks);
      },
    );
  }

  /// Gets a status widget to display below the search bar.
  Widget _getStatus(Widget child) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 30),
      child: child,
    );
  }

  /// Gets a loading status widget.
  Widget _getLoadingStatus() {
    return _getStatus(CircularProgressIndicator());
  }

  /// Gets the status in a case where there are no results.
  Widget _getNoResultsStatus() {
    return _getStatus(
      Text(
        FlutterI18n.translate(context, "main.noResults"),
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  /// Gets a list of track cards to display some [TrackModels].
  Widget _getList(List<TrackModel> tracks) {
    // Generate a list of track card widgets, and add bottom padding.
    List<Widget> items =
        tracks.map((TrackModel track) => trackCard(track, context)).toList();
    items.add(Padding(padding: EdgeInsets.only(top: TRACK_CARD_MARGIN)));

    return ListView(children: items);
  }
}
