import 'package:yes_music/models/state/search_model.dart';

/// A user in a session.
class UserModel {
  /// This user's user ID.
  final String _uid;

  String get uid => _uid;

  /// The current search for this user.
  final SearchModel _search;

  SearchModel get search => _search;

  UserModel(this._uid, this._search);
}
