import 'dart:async';

import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/spotify/data_handler_base.dart';
import 'package:yes_music/data/spotify/spotify_provider.dart';
import 'package:yes_music/models/state/search_model.dart';

/// A bloc that allows the user to search for items.
class SearchBloc implements BlocBase {
  /// The component that handles searching.
  final DataHandlerBase _playbackHandler =
      SpotifyProvider().getDataHandler();

  /// The access token to use to authorize searches.
  final String accessToken;

  /// The [StreamController] that handles the passing of the query to this bloc.
  final StreamController<String> _querySubject =
      StreamController<String>.broadcast();

  StreamSink<String> get querySink => _querySubject.sink;

  StreamSubscription _querySub;

  /// The [BehaviorSubject] that handles the latest search results.
  final BehaviorSubject<SearchModel> _searchSubject = BehaviorSubject();

  ValueObservable<SearchModel> get searchStream => _searchSubject.stream;

  /// The previous operation that is being operated on.
  CancelableOperation<SearchModel> _prevSearch;

  /// Set up stream listeners.
  SearchBloc(this.accessToken) {
    _querySub = _querySubject.stream.listen((String query) {
      // When the query changes, cancel the previous search process.
      _prevSearch?.cancel();

      if (query == null || query.isEmpty) {
        // If we received an empty query, push a null search model.
        _searchSubject.add(null);
      } else {
        // If we received a new query, pass a search model with loading tracks
        // and then perform the search.
        _searchSubject.add(SearchModel.empty());
        _search(query);
      }
    });
  }

  /// Search for some items.
  CancelableOperation<SearchModel> _search(String query) {
    CancelableOperation<SearchModel> search = CancelableOperation.fromFuture(
      _playbackHandler.search(query, accessToken),
    );

    // When the operation completes, update the streams.
    search.value.then((SearchModel model) {
      _searchSubject.add(model);
    });

    // Set the previous operation to this operation.
    _prevSearch = search;
    return search;
  }

  @override
  void dispose() {
    _querySub?.cancel();
    _querySubject.close();
    _searchSubject.close();
  }
}
