import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/data/firebase/auth_handler_base.dart';
import 'package:yes_music/data/firebase/firebase_auth_handler.dart';

/// A bloc handling the state of the login process into Firebase.
class FirebaseConnectBloc implements BlocBase {
  final FirebaseAuthHandler _authHandler;

  ValueObservable<FirebaseAuthState> get stream =>
      _authHandler.firebaseAuthState.stream;

  StreamSink<FirebaseAuthState> get sink => _authHandler.firebaseAuthState.sink;

  FirebaseConnectBloc(this._authHandler);

  void signInSilently() {
    _authHandler.signInSilently();
  }

  void signInWithGoogle() {
    _authHandler.signInWithGoogle();
  }

  void signInWithPhone(String phoneNumber) {
    _authHandler.signInWithPhone(phoneNumber);
  }

  void checkCode(String code) {
    _authHandler.completePhoneSignIn(code);
  }

  @override
  void dispose() {}
}
