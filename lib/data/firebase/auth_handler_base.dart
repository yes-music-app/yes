import 'package:rxdart/rxdart.dart';

enum FirebaseAuthState {
  UNAUTHORIZED,
  AUTHORIZING,
  INVALID_PHONE_NUMBER,
  AWAITING_PHONE_NUMBER,
  FAILED,
  AUTHORIZED,
}

/// A class that handles logging the user in to Firebase.
abstract class AuthHandlerBase {
  /// A [BehaviorSubject] that describes the current state of the login process.
  BehaviorSubject<FirebaseAuthState> get firebaseAuthState;

  /// Attempt to sign in the user in with their Google account.
  void signInWithGoogle();

  /// Attempt to sign the user in with their phone number.
  void signInWithPhone(String phoneNumber);

  /// Complete the phone sign-in process.
  void completePhoneSignIn(String smsCode);

  /// Dispose of this handler.
  void dispose();
}
