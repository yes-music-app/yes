import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/transaction_handler_base.dart';
import 'package:yes_music/models/state/search_model.dart';
import 'package:yes_music/models/state/session_model.dart';
import 'package:yes_music/models/state/user_model.dart';

class FirebaseTransactionHandler implements TransactionHandlerBase {
  static const String SESSION_PATH = "sessions";

  DatabaseReference get _firebase => FirebaseDatabase.instance.reference();

  String _sid;
  DatabaseReference _sessionReference;

  @override
  String get sid => _sid;

  @override
  Future createSession() async {
    bool unique = false;

    while (!unique) {
      _sid = _generateSID();
      _sessionReference = _firebase.child(SESSION_PATH).child(_sid);
      DataSnapshot ref = await _sessionReference.once();
      unique = ref.value == null;
    }

    String uid = await FirebaseProvider().getAuthHandler().uid();
    if (uid == null) {
      _sessionReference = null;
      throw StateError("errors.create.uid");
    }

    UserModel user = UserModel(uid, SearchModel.empty());
    SessionModel session = SessionModel(null, [], [], [user]);
    await _sessionReference.set(session.toMap()).catchError((e) {
      _sessionReference = null;
      throw StateError("errors.create.database");
    });
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
    _sessionReference = _firebase.child(SESSION_PATH).child(casedSID);
    final DataSnapshot snap = await _sessionReference.once();

    if (snap.value == null) {
      _sessionReference = null;
      throw StateError("errors.join.sid");
    }

    String uid = await FirebaseProvider().getAuthHandler().uid();
    if (uid == null) {
      _sessionReference = null;
      throw StateError("errors.join.uid");
    }

    UserModel user = UserModel(uid, SearchModel.empty());
    SessionModel model = SessionModel.fromMap(snap.value);
    model.users.add(user);
    await _sessionReference.set(model.toMap()).catchError((e) {
      _sessionReference = null;
      throw StateError("errors.join.database");
    });
  }
}
