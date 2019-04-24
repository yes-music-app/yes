import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/spotify/data_handler_base.dart';
import 'package:yes_music/data/spotify/spotify_provider.dart';
import 'package:yes_music/models/state/search_model.dart';

/// Tracks the state of a search request.
enum _SearchState {
  LOADING,
  LOADED,
}

/// A bloc that allows the user to search for items.
class SearchBloc implements BlocBase {
  /// The component that handles searching.
  final DataHandlerBase _playbackHandler = SpotifyProvider().getDataHandler();

  /// The access token to use to authorize searches.
  final String accessToken;

  /// The [StreamController] that handles the passing of the query to this bloc.
  final BehaviorSubject<String> _querySubject = BehaviorSubject();

  StreamSink<String> get querySink => _querySubject.sink;

  StreamSubscription _querySub;

  /// The [BehaviorSubject] that handles the latest search results.
  final BehaviorSubject<SearchModel> _searchSubject = BehaviorSubject();

  ValueObservable<SearchModel> get searchStream => _searchSubject.stream;

  /// The previous operation that is being operated on.
  CancelableOperation<SearchModel> _prevSearch;

  /// Whether we are currently loading more.
  _SearchState loadingState = _SearchState.LOADED;

  /// Set up stream listeners.
  SearchBloc(this.accessToken) {
    _querySub = _querySubject.listen((String query) {
      // When the query changes, cancel the previous search process.
      _prevSearch?.cancel();

      if (query == null || query.isEmpty) {
        // If we received an empty query, push a null search model.
        if (_searchSubject.value != null) {
          _searchSubject.add(null);
        }
      } else {
        // If we received a new query, pass a search model with loading tracks
        // and then perform the search.
        _searchSubject.add(SearchModel.empty());
        _search();
      }
    });
  }

  /// If the UI asks to load more, search for more.
  void loadMore() {
    if (loadingState == _SearchState.LOADED) {
      _search();
    }
  }

  /// Search for more items.
  void _search() {
    // Indicate the we are currently loading.
    loadingState = _SearchState.LOADING;

    // Retrieve the last search model.
    SearchModel lastModel = _searchSubject.value;
    if (lastModel?.tracks == null) {
      lastModel = SearchModel([], 50);
    }

    // Start the search.
    CancelableOperation<SearchModel> search = CancelableOperation.fromFuture(
      _playbackHandler.search(
        _querySubject.value,
        accessToken,
        prevTracks: lastModel.tracks,
        limit: min(20, lastModel.remainder),
      ),
    );

    // When the operation completes, update the streams.
    search.value.then((SearchModel model) {
      loadingState = _SearchState.LOADED;
      _searchSubject.add(model);
    });

    // Set the previous operation to this operation.
    _prevSearch = search;
  }

  @override
  void dispose() {
    _querySub?.cancel();
    _querySubject.close();
    _searchSubject.close();
  }
}
