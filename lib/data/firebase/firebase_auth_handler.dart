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
  Future<bool> isSignedInWithGoogle() {
    return _googleSignIn.isSignedIn();
  }

  @override
  Future<GoogleSignInAccount> signInSilently() async {
    return await _googleSignIn.signInSilently().catchError((e) => null);
  }

  @override
  Future<GoogleSignInAccount> signInWithGoogle() async {
    return await _googleSignIn.signIn().catchError((e) => null);
  }

  @override
  Future<AuthCredential> getCredentials(GoogleSignInAccount account) async {
    final GoogleSignInAuthentication auth = await account.authentication;

    if (auth == null || auth.idToken == null || auth.accessToken == null) {
      throw new StateError("Received invalid auth from Google account.");
    }

    return GoogleAuthProvider.getCredential(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );
  }

  @override
  Future<bool> signInWithCredential(AuthCredential credential) async {
    final FirebaseUser user = await _firebaseAuth
        .signInWithCredential(credential)
        .catchError((e) => null);
    final FirebaseUser currentUser =
        await _firebaseAuth.currentUser().catchError((e) => null);

    if (user == null ||
        currentUser == null ||
        user.uid != currentUser.uid ||
        await user.getIdToken() == null) {
      return false;
    }

    return true;
  }

  @override
  void signOut() {
    _googleSignIn.signOut();
    _firebaseAuth.signOut();
  }
}
