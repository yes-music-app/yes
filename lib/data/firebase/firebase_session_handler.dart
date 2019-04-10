import 'package:firebase_database/firebase_database.dart';
import 'package:yes_music/data/firebase/session_handler_base.dart';

const String SESSION_PATH = "sessions";
const String HOST_PATH = "host";
const String USER_PATH = "users";

class FirebaseSessionHandler implements SessionHandlerBase {
  DatabaseReference get _firebase => FirebaseDatabase.instance.reference();

  @override
  Future<Stream<Event>> sessionStateSubscribe(String sid) async {
    DatabaseReference sessionReference =
        _firebase.child(SESSION_PATH).child(sid);
    DataSnapshot snapshot = await sessionReference.once();
    if(snapshot == null || snapshot.value == null) {
      throw new StateError("main.sid");
    }

    return sessionReference.onValue;
  }
}
