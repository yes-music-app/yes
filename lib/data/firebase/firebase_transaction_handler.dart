import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/transaction_handler_base.dart';
import 'package:yes_music/models/state/search_model.dart';
import 'package:yes_music/models/state/session_model.dart';
import 'package:yes_music/models/state/user_model.dart';

class FirebaseTransactionHandler implements TransactionHandlerBase {
  static const String SESSION_PATH = "sessions";

  String _sid;
  DocumentReference _sessionReference;

  @override
  String get sid => _sid;

  @override
  Future<bool> createSession() async {
    bool unique = false;

    while (!unique) {
      _sid = _generateSID();
      _sessionReference =
          Firestore.instance.collection(SESSION_PATH).document(_sid);
      DocumentSnapshot ref = await _sessionReference.get();
      unique = !ref.exists;
    }

    String uid = await new FirebaseProvider().getAuthHandler().uid();
    if (uid == null) {
      _sessionReference = null;
      return false;
    }

    UserModel user = new UserModel(uid, new SearchModel("", []));
    SessionModel session = new SessionModel(null, [], [], [user]);
    bool success = await _sessionReference.setData(session.toMap()).then(
      (value) {
        return true;
      },
      onError: (e) {
        _sessionReference = null;
        return false;
      },
    );

    return success;
  }

  String _generateSID() {
    Random random = new Random();

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
    _sessionReference =
        Firestore.instance.collection(SESSION_PATH).document(casedSID);
    final DocumentSnapshot snap = await _sessionReference.get();

    print(snap.data);

    if (snap == null || snap.data == null) {
      _sessionReference = null;
      throw new StateError("errors.join.sid");
    }

    String uid = await new FirebaseProvider().getAuthHandler().uid();
    if (uid == null) {
      _sessionReference = null;
      throw new StateError("errors.join.uid");
    }

    UserModel user = new UserModel(uid, new SearchModel("", []));
    SessionModel model = SessionModel.fromMap(snap.data);
    model.users.add(user);
    await _sessionReference.setData(model.toMap()).catchError(
      (e) {
        _sessionReference = null;
        throw new StateError("errors.join.database");
      },
    );
  }
}
