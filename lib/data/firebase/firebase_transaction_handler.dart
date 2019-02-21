import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/transaction_handler_base.dart';
import 'package:yes_music/models/state/search_model.dart';
import 'package:yes_music/models/state/session_model.dart';
import 'package:yes_music/models/state/user_model.dart';

class FirebaseTransactionHandler implements TransactionHandlerBase {
  static const String SESSION_PATH = "sessions";

  String _sid;
  DocumentReference _sessionReference;

  final BehaviorSubject<CreateSessionState> _createState =
      new BehaviorSubject<CreateSessionState>(
          seedValue: CreateSessionState.NOT_CREATED);
  final BehaviorSubject<JoinSessionState> _joinState =
      new BehaviorSubject<JoinSessionState>(
          seedValue: JoinSessionState.NOT_JOINED);

  @override
  String get sid => _sid;

  @override
  BehaviorSubject<CreateSessionState> get createState => _createState;

  @override
  BehaviorSubject<JoinSessionState> get joinState => _joinState;

  @override
  void createSession() async {
    _createState.add(CreateSessionState.CREATING);

    String id;
    bool unique = false;

    while (!unique) {
      id = _generateSID();
      _sessionReference =
          Firestore.instance.collection(SESSION_PATH).document(id);
      DocumentSnapshot ref = await _sessionReference.get();
      unique = ref == null;
    }

    String uid = await new FirebaseProvider().getAuthHandler().uid();
    if (uid == null) {
      _sessionReference = null;
      _createState.add(CreateSessionState.FAILED);
      return;
    }

    UserModel user = new UserModel(uid, new SearchModel("", []));
    SessionModel session = new SessionModel(null, [], [], [user]);
    _sessionReference.setData(session.toMap()).then((value) {
      _createState.add(CreateSessionState.CREATED);
    }, onError: (e) {
      _sessionReference = null;
      _createState.add(CreateSessionState.FAILED);
    });
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
  void joinSession(String sid) async {
    _joinState.add(JoinSessionState.JOINING);

    final String casedSID = sid.toUpperCase();
    _sessionReference =
        Firestore.instance.collection(SESSION_PATH).document(casedSID);
    final DocumentSnapshot snap = await _sessionReference.get();

    if (snap == null) {
      _sessionReference = null;
      _joinState.add(JoinSessionState.FAILED);
      return;
    }

    String uid = await new FirebaseProvider().getAuthHandler().uid();
    if (uid == null) {
      _sessionReference = null;
      _joinState.add(JoinSessionState.FAILED);
      return;
    }

    UserModel user = new UserModel(uid, new SearchModel("", []));
    DocumentSnapshot snapshot = await _sessionReference.get();
    if (snapshot == null) {
      _sessionReference = null;
      _joinState.add(JoinSessionState.FAILED);
      return;
    }

    SessionModel model = SessionModel.fromMap(snapshot.data);
    model.users.add(user);
    _sessionReference.setData(model.toMap());

    _joinState.add(JoinSessionState.JOINED);
  }

  @override
  void dispose() {
    _createState.close();
    _joinState.close();
  }
}
