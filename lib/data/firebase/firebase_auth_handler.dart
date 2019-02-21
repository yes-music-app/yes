import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yes_music/data/firebase/auth_handler_base.dart';

class FirebaseAuthHandler implements AuthHandlerBase {
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId;

  BehaviorSubject<FirebaseAuthState> _firebaseAuthState =
      new BehaviorSubject(seedValue: FirebaseAuthState.UNAUTHORIZED);

  @override
  BehaviorSubject<FirebaseAuthState> get firebaseAuthState =>
      _firebaseAuthState;

  @override
  Future<String> uid() async {
    FirebaseUser user = await _firebaseAuth?.currentUser();
    return user?.uid;
  }

  @override
  void signInSilently() async {
    _firebaseAuthState.add(FirebaseAuthState.AUTHORIZING_SILENTLY);

    final GoogleSignInAccount googleAccount =
        await _googleSignIn.signInSilently();

    if (googleAccount == null) {
      _firebaseAuthState.add(FirebaseAuthState.UNAUTHORIZED_SILENTLY);
      return;
    }

    _signInWithGoogleAccount(googleAccount);
  }

//  @override
//  void signInSilently() async {
//    await _googleSignIn.signOut();
//    _firebaseAuthState.add(FirebaseAuthState.UNAUTHORIZED_SILENTLY);
//  }

  @override
  void signInWithGoogle() async {
    _firebaseAuthState.add(FirebaseAuthState.AUTHORIZING);

    final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();

    if (googleAccount == null) {
      _firebaseAuthState.add(FirebaseAuthState.FAILED);
      return;
    }

    _signInWithGoogleAccount(googleAccount);
  }

  @override
  Future<bool> isSignedInWithGoogle() {
    return _googleSignIn.isSignedIn();
  }

  void _signInWithGoogleAccount(GoogleSignInAccount googleAccount) async {
    final GoogleSignInAuthentication googleAuth =
        await googleAccount.authentication;

    if (googleAuth == null) {
      _firebaseAuthState.add(FirebaseAuthState.FAILED);
      return;
    }

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    _signInWithCredentials(credential);
  }

  @override
  void signInWithPhone(String phoneNumber) async {
    _firebaseAuthState.add(FirebaseAuthState.AUTHORIZING);

    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      _firebaseAuthState.add(FirebaseAuthState.AUTHORIZED);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      _firebaseAuthState.add(FirebaseAuthState.FAILED);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) {
      _firebaseAuthState.add(FirebaseAuthState.AWAITING_PHONE_CODE);
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _firebaseAuth
        .verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 30),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        )
        .catchError(
          (e) => _firebaseAuthState.add(FirebaseAuthState.FAILED),
        );
  }

  @override
  void completePhoneSignIn(String smsCode) {
    _firebaseAuthState.add(FirebaseAuthState.AUTHORIZING);

    if (_verificationId == null) {
      _firebaseAuthState.add(FirebaseAuthState.FAILED);
      return;
    }

    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

    _signInWithCredentials(credential);
  }

  void _signInWithCredentials(AuthCredential credential) async {
    final FirebaseUser user =
        await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser currentUser = await _firebaseAuth.currentUser();

    if (user == null ||
        currentUser == null ||
        user.uid != currentUser.uid ||
        await user.getIdToken() == null) {
      _firebaseAuthState.add(FirebaseAuthState.FAILED);
      return;
    }

    _firebaseAuthState.add(FirebaseAuthState.AUTHORIZED);
  }

  @override
  void dispose() {
    _firebaseAuthState.close();
  }
}
