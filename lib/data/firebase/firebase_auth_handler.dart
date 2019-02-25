import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yes_music/data/firebase/auth_handler_base.dart';

class FirebaseAuthHandler implements AuthHandlerBase {
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> uid() async {
    FirebaseUser user = await _firebaseAuth?.currentUser();
    return user?.uid;
  }

  @override
  Future<GoogleSignInAccount> signInSilently() async {
    return await _googleSignIn.signInSilently().catchError((e) => null);
  }

  @override
  Future<GoogleSignInAccount> signInWithGoogle() async {
    GoogleSignInAccount account = await _googleSignIn.signIn();
    if (account == null) {
      throw new StateError("errors.login.googleSignIn");
    }

    return account;
  }

  @override
  Future<AuthCredential> getCredential(GoogleSignInAccount account) async {
    final GoogleSignInAuthentication auth = await account.authentication;

    if (auth == null || auth.idToken == null || auth.accessToken == null) {
      throw new StateError("errors.login.auth");
    }

    AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );

    if (credential == null) {
      throw new StateError("errors.login.credential");
    }

    return credential;
  }

  @override
  Future signInWithCredential(AuthCredential credential) async {
    final FirebaseUser user = await _firebaseAuth
        .signInWithCredential(credential)
        .catchError((e) => throw new StateError("errors.login.signIn"));
    final FirebaseUser currentUser = await _firebaseAuth
        .currentUser()
        .catchError((e) => throw new StateError("errors.login.signIn"));

    if (user == null ||
        currentUser == null ||
        user.uid != currentUser.uid ||
        await user.getIdToken() == null) {
      throw new StateError("errors.login.signIn");
    }
  }

  @override
  void signOut() {
    _googleSignIn.signOut();
    _firebaseAuth.signOut();
  }
}
