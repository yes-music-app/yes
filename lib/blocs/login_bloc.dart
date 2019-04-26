import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/utils/bloc_provider.dart';
import 'package:yes_music/data/firebase/auth_handler_base.dart';
import 'package:yes_music/data/firebase/firebase_provider.dart';
import 'package:yes_music/feature_flags/flag_provider.dart';
import 'package:yes_music/feature_flags/index.dart';

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
  BehaviorSubject<FirebaseAuthState> _firebaseAuthState =
      BehaviorSubject.seeded(FirebaseAuthState.UNAUTHORIZED);

  ValueObservable<FirebaseAuthState> get stream => _firebaseAuthState.stream;

  StreamSink<FirebaseAuthState> get sink => _firebaseAuthState.sink;

  /// A subscription to the auth state stream.
  StreamSubscription<FirebaseAuthState> _sub;

  /// The [BehaviorSubject] that broadcasts the curred uid.
  BehaviorSubject<String> _uidSubject = BehaviorSubject();

  ValueObservable<String> get uidStream => _uidSubject.stream;

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
    if (FlagProvider().getFlag(SIGN_OUT)) {
      await _authHandler.signOut();
    }

    GoogleSignInAccount googleAccount =
        await _authHandler.signInSilently().catchError((e) {
      _firebaseAuthState.addError(e);
      return;
    });

    if (googleAccount == null) {
      _firebaseAuthState.add(FirebaseAuthState.UNAUTHORIZED_SILENTLY);
      return;
    }

    _signInWithAccount(googleAccount);
  }

  /// Attempts to sign the user in with a prompt.
  void _signInWithGoogle() async {
    _authHandler.signInWithGoogle().then((GoogleSignInAccount googleAccount) {
      _signInWithAccount(googleAccount);
    }).catchError((e) {
      _firebaseAuthState.addError(e);
    });
  }

  /// Attempts to sign the user in to Firebase with their Google account.
  void _signInWithAccount(GoogleSignInAccount account) async {
    AuthCredential credential =
        await _authHandler.getCredential(account).catchError((e) {
      _firebaseAuthState.addError(e);
      return;
    });

    _authHandler.signInWithCredential(credential).then((String uid) {
      _uidSubject.add(uid);
      _firebaseAuthState.add(FirebaseAuthState.AUTHORIZED);
    }).catchError((e) {
      _firebaseAuthState.addError(e);
    });
  }

  /// Signs the user out of their Google account.
  void _signOut() async {
    _authHandler.signOut().then((_) {
      _uidSubject.add(null);
      _firebaseAuthState.add(FirebaseAuthState.UNAUTHORIZED);
    }).catchError((e) {
      _firebaseAuthState.addError(e);
    });
  }

  @override
  void dispose() async {
    _sub.cancel();
    _firebaseAuthState.close();
    _uidSubject.close();
  }
}
