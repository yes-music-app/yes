import 'package:firebase_database/firebase_database.dart';
import 'package:yes_music/data/firebase/session_handler_base.dart';
import 'package:yes_music/models/state/session_model.dart';

class FirebaseSessionHandler implements SessionHandlerBase {
  DatabaseReference get _firebase => FirebaseDatabase.instance.reference();

  @override
  Future<Stream<Event>> sessionStateSubscribe(String sid) async {
    DatabaseReference sessionReference =
        _firebase.child(SESSION_PATH).child(sid);
    DataSnapshot snapshot = await sessionReference.once();
    if (snapshot == null || snapshot.value == null) {
      throw new StateError("main.sid");
    }

    return sessionReference.onValue;
  }

  @override
  Future<Stream<Event>> getSIDStream(String sid) async {
    DatabaseReference sessionReference =
        _firebase.child(SESSION_PATH).child(sid);
    DataSnapshot snapshot = await sessionReference.once();
    if (snapshot == null || snapshot.value == null) {
      throw new StateError("errors.main.sid");
    }

    DatabaseReference sidReference = sessionReference.child(SID_PATH);
    snapshot = await sidReference.once();
    if (snapshot == null || snapshot.value == null) {
      throw new StateError("errors.main.sid");
    }

    return sidReference.onValue;
  }

  @override
  Future<Stream<Event>> getHostStream(String sid) async {
    DatabaseReference sessionReference =
        _firebase.child(SESSION_PATH).child(sid);
    DataSnapshot snapshot = await sessionReference.once();
    if (snapshot == null || snapshot.value == null) {
      throw new StateError("errors.main.sid");
    }

    DatabaseReference hostReference = sessionReference.child(HOST_PATH);
    snapshot = await hostReference.once();
    if (snapshot == null || snapshot.value == null) {
      throw new StateError("errors.main.sid");
    }

    return hostReference.onValue;
  }
}
