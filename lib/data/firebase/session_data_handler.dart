import 'package:firebase_database/firebase_database.dart';
import 'package:yes_music/data/firebase/session_data_handler_base.dart';
import 'package:yes_music/models/state/session_model.dart';

class SessionDataHandler implements SessionDataHandlerBase {
  /// A reference to the root of the Firebase database.
  final DatabaseReference _firebase =
      FirebaseDatabase.instance.reference().child(SESSION_KEY);

  @override
  Future<Stream<SessionModel>> getSessionModelStream(String sid) async {
    final DatabaseReference sessionReference = _firebase.child(sid);
    final DataSnapshot sessionSnapshot = await sessionReference.once();
    if (sessionSnapshot == null || sessionSnapshot.value == null) {
      throw StateError("errors.session.no_remote_session");
    }

    return sessionReference.onValue.map<SessionModel>(
      (Event data) => SessionModel.fromMap(data.snapshot.value),
    );
  }
}
