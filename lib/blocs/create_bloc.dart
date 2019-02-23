import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/data/firebase/firebase_transaction_handler.dart';

enum CreateSessionState {
  NOT_CREATED,
  CREATING,
  CREATED,
  FAILED,
}

class CreateBloc implements BlocBase {
  final FirebaseTransactionHandler _transactionHandler;
  StreamSubscription<CreateSessionState> _sub;

  BehaviorSubject<CreateSessionState> _createState =
      new BehaviorSubject(seedValue: CreateSessionState.NOT_CREATED);

  ValueObservable<CreateSessionState> get stream => _createState.stream;

  StreamSink<CreateSessionState> get sink => _createState.sink;

  String get sid => _transactionHandler.sid;

  CreateBloc(this._transactionHandler) {
    _sub = _createState.listen((CreateSessionState state) {
      switch (state) {
        case CreateSessionState.CREATING:
          _createSession();
          break;
        default:
          break;
      }
    });
  }

  void _createSession() {
    _transactionHandler.createSession().then((bool success) {
      if (success) {
        _createState.add(CreateSessionState.CREATED);
      } else {
        _createState.add(CreateSessionState.FAILED);
      }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    _createState.close();
  }
}
