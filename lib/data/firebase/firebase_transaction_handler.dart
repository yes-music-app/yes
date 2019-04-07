import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/transaction_handler_base.dart';
import 'package:yes_music/models/state/search_model.dart';
import 'package:yes_music/models/state/session_model.dart';
import 'package:yes_music/models/state/user_model.dart';

const String SESSION_PATH = "sessions";
const String HOST_PATH = "host";
const String USER_PATH = "users";

class FirebaseTransactionHandler implements TransactionHandlerBase {
  DatabaseReference get _firebase => FirebaseDatabase.instance.reference();

  String _sid;

  @override
  String get sid => _sid?.toUpperCase();

  void _setSID(String sid) async {
    _sid = sid.toUpperCase();

    // Persist the new SID so that it can be accessed the next time we load
    // into the app.

    String uid = await FirebaseProvider().getAuthHandler().uid();
    if (uid == null || uid.isEmpty) {
      throw StateError("errors.database.uid");
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(uid, _sid);
  }

  @override
  Future createSession() async {
    bool unique = false;
    String tempSID;
    DatabaseReference sessionReference;

    while (!unique) {
      tempSID = _generateSID();
      sessionReference = _firebase.child(SESSION_PATH).child(tempSID);
      DataSnapshot ref = await sessionReference.once();
      unique = ref.value == null;
    }

    String uid = await FirebaseProvider().getAuthHandler().uid();
    if (uid == null) {
      throw StateError("errors.create.uid");
    }

    UserModel user = UserModel(uid, SearchModel.empty());
    SessionModel session = SessionModel.empty(user);
    await sessionReference.set(session.toMap()).catchError((e) {
      throw StateError("errors.database.connect");
    });

    _setSID(tempSID);
  }

  String _generateSID() {
    Random random = Random();

    List<int> codes = [];
    for (int i = 0; i < 6; i++) {
      int code = random.nextInt(36);
      if (code < 10) {
        code += 48;
      } else {
        code += 55;
      }
      codes.add(code);
    }

    return String.fromCharCodes(codes);
  }

  @override
  Future joinSession(String sid) async {
    final String casedSID = sid.toUpperCase();
    DatabaseReference sessionReference =
        _firebase.child(SESSION_PATH).child(casedSID);
    final DataSnapshot snap = await sessionReference.once();

    if (sid.isEmpty || snap.value == null) {
      throw StateError("errors.join.sid");
    }

    String uid = await FirebaseProvider().getAuthHandler().uid();
    if (uid == null) {
      throw StateError("errors.join.uid");
    }

    UserModel user = UserModel(uid, SearchModel.empty());
    SessionModel model = SessionModel.fromMap(snap.value);
    model.users.add(user);
    await sessionReference.set(model.toMap()).catchError((e) {
      throw StateError("errors.database.connect");
    });

    _setSID(sid);
  }

  @override
  Future leaveSession({leaveID}) async {
    if (leaveID == null || leaveID.isEmpty) {
      leaveID = _sid;
    }

    if (leaveID == null || leaveID.isEmpty) {
      // If there is no current session, just return.
      return;
    }

    final String casedSid = leaveID.toUpperCase();

    String uid = await FirebaseProvider().getAuthHandler().uid();
    if (uid == null || uid.isEmpty) {
      // If there is no current user, just return.
      return;
    }

    DatabaseReference sessionReference =
        _firebase.child(SESSION_PATH).child(casedSid);
    if (await sessionReference.once() == null) {
      // If the session doesn't exist, just return.
      return;
    }

    DataSnapshot hostSnap = await sessionReference.child(HOST_PATH).once();
    if (hostSnap?.value == uid) {
      // If the user is the host, delete the entire session.
      await sessionReference.remove().catchError((e) {
        throw StateError("errors.database.operation");
      });
      return;
    }

    DatabaseReference userReference =
        sessionReference.child(USER_PATH).child(uid);
    if (await userReference.once() == null) {
      // If the user is not in the session, just return.
      return;
    }

    await userReference.remove().then((val) {
      _setSID(null);
    }).catchError((e) {
      throw StateError("errors.database.operation");
    });
  }

  @override
  Future<String> findSession() async {
    if (sid != null && sid.isNotEmpty) {
      return sid;
    }

    String uid = await FirebaseProvider().getAuthHandler().uid();
    if (uid == null || uid.isEmpty) {
      throw StateError("errors.database.uid");
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String oldSID = prefs.getString(uid);

    if (oldSID == null || oldSID.isEmpty) {
      return null;
    }

    DatabaseReference sessionReference =
        _firebase.child(SESSION_PATH).child(oldSID);
    if (await sessionReference.once() == null) {
      // If the session doesn't exist, just return null.
      return null;
    }

    return oldSID;
  }
}
