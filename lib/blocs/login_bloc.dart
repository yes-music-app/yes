import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/auth_handler_base.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';

/// An enumeration of the potential states that a login operation can be in.
enum FirebaseAuthState {
  UNAUTHORIZED,
  AUTHORIZING_SILENTLY,
  UNAUTHORIZED_SILENTLY,
  AUTHORIZING,
  AUTHORIZED,
  SIGNING_OUT,
}

/// A bloc handling the state of the login process into Firebase.
class LoginBloc implements BlocBase {
  /// The [AuthHandlerBase] that performs the auth operations.
  final AuthHandlerBase _authHandler = FirebaseProvider().getAuthHandler();

  /// The [BehaviorSubject] that broadcasts the current state of the user's
  /// attempt to authenticate with Firebase.
  BehaviorSubject<FirebaseAuthState> _firebaseAuthState = BehaviorSubject(
    seedValue: FirebaseAuthState.UNAUTHORIZED,
  );

  ValueObservable<FirebaseAuthState> get stream => _firebaseAuthState.stream;

  StreamSink<FirebaseAuthState> get sink => _firebaseAuthState.sink;

  /// A subscription to the auth state stream.
  StreamSubscription<FirebaseAuthState> _sub;

  LoginBloc() {
    _sub = _firebaseAuthState.listen((FirebaseAuthState state) {
      // If we receive a signal to authorize from the UI, begin that process.
      switch (state) {
        case FirebaseAuthState.AUTHORIZING_SILENTLY:
          _signInSilently();
          break;
        case FirebaseAuthState.AUTHORIZING:
          _signInWithGoogle();
          break;
        case FirebaseAuthState.SIGNING_OUT:
          _signOut();
          break;
        default:
          break;
      }
    });
  }

  /// Attempts to sign the user in without a prompt.
  void _signInSilently() async {
    GoogleSignInAccount googleAccount = await _authHandler.signInSilently();

    if (googleAccount == null) {
      _firebaseAuthState.add(FirebaseAuthState.UNAUTHORIZED_SILENTLY);
      return;
    }

    _signInWithAccount(googleAccount);
  }

  /// Attempts to sign the user in with a prompt.
  void _signInWithGoogle() async {
    GoogleSignInAccount googleAccount;

    try {
      googleAccount = await _authHandler.signInWithGoogle();
    } catch (e) {
      _firebaseAuthState.addError(StateError("errors.login.googleSignIn"));
      return;
    }

    _signInWithAccount(googleAccount);
  }

  /// Attempts to sign the user in to Firebase with their Google account.
  void _signInWithAccount(GoogleSignInAccount account) async {
    try {
      AuthCredential credential = await _authHandler.getCredential(account);
      await _authHandler.signInWithCredential(credential);
    } on StateError catch (e) {
      _firebaseAuthState.addError(e);
    }

    _firebaseAuthState.add(FirebaseAuthState.AUTHORIZED);
  }

  /// Signs the user out of their Google account.
  void _signOut() async {
    try {
      await _authHandler.signOut();
    } on StateError catch (e) {
      _firebaseAuthState.addError(e);
    }

    _firebaseAuthState.add(FirebaseAuthState.UNAUTHORIZED);
  }

  @override
  void dispose() async {
    await _sub.cancel();
    _firebaseAuthState.close();
  }
}
