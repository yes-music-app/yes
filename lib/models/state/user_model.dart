import 'package:yes_music/models/state/search_model.dart';

/// A user in a session.
class UserModel {
  /// This user's user ID.
  final String uid;

  /// The current search for this user.
  final SearchModel search;

  UserModel(this.uid, this.search);
}
