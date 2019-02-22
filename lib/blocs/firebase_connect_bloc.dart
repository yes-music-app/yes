import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/data/firebase/firebase_auth_handler.dart';

enum FirebaseAuthState {
  UNAUTHORIZED,
  AUTHORIZING_SILENTLY,
  UNAUTHORIZED_SILENTLY,
  AUTHORIZING,
  AUTHORIZED,
  FAILED,
}

/// A bloc handling the state of the login process into Firebase.
class FirebaseConnectBloc implements BlocBase {
  final FirebaseAuthHandler _authHandler;

  BehaviorSubject<FirebaseAuthState> _firebaseAuthState =
      new BehaviorSubject(seedValue: FirebaseAuthState.UNAUTHORIZED);

  ValueObservable<FirebaseAuthState> get stream => _firebaseAuthState.stream;

  StreamSink<FirebaseAuthState> get sink => _firebaseAuthState.sink;

  FirebaseConnectBloc(this._authHandler) {
    stream.listen((FirebaseAuthState state) {
      switch (state) {
        case FirebaseAuthState.AUTHORIZING_SILENTLY:
          this._signInSilently();
          break;
        case FirebaseAuthState.AUTHORIZING:
          this._signInWithGoogle();
          break;
        default:
          break;
      }
    });
  }

  void _signInSilently() async {
    GoogleSignInAccount googleAccount = await _authHandler.signInSilently();

    if (googleAccount == null) {
      _firebaseAuthState.add(FirebaseAuthState.UNAUTHORIZED_SILENTLY);
      return;
    }

    _signInWithAccount(googleAccount);
  }

  void _signInWithGoogle() async {
    GoogleSignInAccount googleAccount = await _authHandler.signInWithGoogle();

    if (googleAccount == null) {
      _firebaseAuthState.add(FirebaseAuthState.FAILED);
      return;
    }

    _signInWithAccount(googleAccount);
  }

  void _signInWithAccount(GoogleSignInAccount account) async {
    AuthCredential credential = await _authHandler
        .getCredentials(account)
        .catchError((e) => null);

    if (credential == null) {
      _firebaseAuthState.add(FirebaseAuthState.FAILED);
      return;
    }

    bool success = await _authHandler.signInWithCredential(credential);

    _firebaseAuthState
        .add(success ? FirebaseAuthState.AUTHORIZED : FirebaseAuthState.FAILED);
  }

  @override
  void dispose() {
    _firebaseAuthState.close();
  }
}
