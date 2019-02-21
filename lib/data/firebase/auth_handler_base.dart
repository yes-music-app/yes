import 'package:rxdart/rxdart.dart';

enum FirebaseAuthState {
  UNAUTHORIZED,
  AUTHORIZING_SILENTLY,
  UNAUTHORIZED_SILENTLY,
  AWAITING_PHONE_NUMBER,
  AWAITING_PHONE_CODE,
  AUTHORIZING,
  AUTHORIZED,
  FAILED,
}

/// A class that handles logging the user in to Firebase.
abstract class AuthHandlerBase {
  /// A [BehaviorSubject] that describes the current state of the login process.
  BehaviorSubject<FirebaseAuthState> get firebaseAuthState;

  /// Get the current user's user ID.
  Future<String> uid();

  /// Attempt to sign the user in silently.
  void signInSilently();

  /// Attempt to sign in the user in with their Google account.
  void signInWithGoogle();

  /// Determine whether the user is currently signed in with Google.
  Future<bool> isSignedInWithGoogle();

  /// Attempt to sign the user in with their phone number.
  void signInWithPhone(String phoneNumber);

  /// Complete the phone sign-in process.
  void completePhoneSignIn(String smsCode);

  /// Dispose of this handler.
  void dispose();
}
