import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yes_music/blocs/search_bloc.dart';
import 'package:yes_music/blocs/session_data_bloc.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/components/common/track_card.dart';
import 'package:yes_music/models/spotify/track_model.dart';
import 'package:yes_music/models/state/search_model.dart';

/// A screen that allows the user to search for tracks to add.
class SearchScreen extends StatefulWidget {
  final SessionDataBloc _dataBloc;

  SearchScreen(this._dataBloc);

  @override
  State<StatefulWidget> createState() => _SearchScreenState(_dataBloc);
}

/// A class that represents the state of a [SearchScreen].
class _SearchScreenState extends State<SearchScreen> {
  /// The bloc that handles searching.
  SearchBloc _searchBloc;

  /// The bloc that handles data.
  SessionDataBloc _dataBloc;

  /// The text editing controller to use to control the query.
  final TextEditingController _queryController = TextEditingController();
  String _oldText;

  /// The scroll controller used to monitor list scrolls.
  final ScrollController _scrollController = ScrollController();

  _SearchScreenState(this._dataBloc);

  /// Initialize the search bloc and register listeners.
  @override
  void initState() {
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    _queryController.addListener(_queryListener);
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: _getBody(),
    );
  }

  /// Listens to the query text controller and updates the bloc with query
  /// updates.
  void _queryListener() {
    if (_oldText != _queryController.text) {
      _searchBloc.querySink.add(_queryController.text);
      _oldText = _queryController.text;
    }
  }

  /// Listens to the scroll controller and updates the bloc for new searches
  /// when scrolled to the bottom.
  void _scrollListener() {
    if (_searchBloc.searchStream.value?.tracks != null &&
        _searchBloc.searchStream.value.remainder > 0 &&
        _scrollController.offset >=
            _scrollController.position.maxScrollExtent - 50) {
      // If we have reached the bottom of the base, load more items.
      _searchBloc.loadMore();
    }
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
      controller: _queryController,
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
      onPressed: _queryController.clear,
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
        return _getList(snapshot.data);
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
  Widget _getList(SearchModel model) {
    // Generate a list of track card widgets, and add bottom padding.
    List<Widget> items = model.tracks
        .map((TrackModel track) => trackCard(
              track,
              context,
              actionIcon: Icon(Icons.add),
              onAction: () {
                _dataBloc.queueSink.add(track);
              },
            ))
        .toList();
    items.add(Padding(padding: EdgeInsets.only(top: TRACK_CARD_MARGIN * 2)));

    // If there are remaining results, show a loading indicator; otherwise,
    // indicate that there are no remaining results.
    items.add(
      Center(
        child: model.remainder > 0
            ? CircularProgressIndicator()
            : Text(
                FlutterI18n.translate(context, "main.noMoreResults"),
                style: Theme.of(context).textTheme.caption,
              ),
      ),
    );

    items.add(Padding(padding: EdgeInsets.only(top: TRACK_CARD_MARGIN * 2)));

    return ListView(
      children: items,
      controller: _scrollController,
    );
  }
}
