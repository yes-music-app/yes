import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// A class that handles logging the user in to Firebase.
abstract class AuthHandlerBase {
  /// Get the current user's user ID.
  Future<String> uid({bool checked = true});

  /// Attempt to sign the user in silently.
  Future<GoogleSignInAccount> signInSilently();

  /// Attempt to sign the user in manually.
  Future<GoogleSignInAccount> signInWithGoogle();

  /// Attempt to get the user's sign in credentials with their Google account.
  Future<AuthCredential> getCredential(GoogleSignInAccount account);

  /// Attempt to sign the user in with their Firebase auth credentials.
  Future<String> signInWithCredential(AuthCredential credential);

  /// Sign the user out of their Google account.
  Future signOut();
}
