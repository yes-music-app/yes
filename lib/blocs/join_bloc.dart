import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/data/firebase/firebase_transaction_handler.dart';

enum JoinSessionState {
  NOT_JOINED,
  JOINING,
  JOINED,
  FAILED,
}

class JoinBloc implements BlocBase {
  final FirebaseTransactionHandler _transactionhandler =
      new FirebaseProvider().getTransactionHandler();
  StreamSubscription<JoinSessionState> _sub;

  BehaviorSubject<JoinSessionState> _joinState = new BehaviorSubject(
    seedValue: JoinSessionState.NOT_JOINED,
  );

  ValueObservable<JoinSessionState> get stream => _joinState.stream;

  StreamSink<JoinSessionState> get sink => _joinState.sink;

  JoinBloc() {
    _sub = _joinState.listen((JoinSessionState state) {});
  }

  void _joinSession(String sid) {
    _transactionhandler.joinSession(sid).then((bool success) {
      if (success) {
        _joinState.add(JoinSessionState.JOINED);
      } else {
        _joinState.add(JoinSessionState.FAILED);
      }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    _joinState.close();
  }
}
