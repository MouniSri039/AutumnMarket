
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  // Stable stream used by AuthGate.
  late final Stream<User?> authStateChanges =
      _auth.authStateChanges();

  // Currently signed-in user.
  User? get currentUser => _auth.currentUser;

  // Register a new account.
  Future<UserCredential> register(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Sign in an existing account.
  Future<UserCredential> signIn(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Sign out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Update password, reauthenticating if Firebase requires it.
  Future<void> changePassword({
    required String newPassword,
    required String currentPassword,
  }) async {
    final user = _auth.currentUser;

    if (user == null || user.email == null) {
      throw StateError('A signed-in user is required.');
    }

    try {
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (error) {
      if (error.code != 'requires-recent-login') {
        rethrow;
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Retry after successful reauthentication.
      await user.updatePassword(newPassword);
    }
  }

  // Convert Firebase errors into safe, readable messages.
  String errorMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Please check your email address format.';

        case 'weak-password':
          return 'Your password must contain at least 6 characters.';

        case 'email-already-in-use':
          return 'This email already has an account. Please sign in instead.';

        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          return 'Email or password is incorrect.';

        case 'operation-not-allowed':
          return 'This sign-in method is currently unavailable.';

        case 'too-many-requests':
          return 'Too many attempts. Please wait and try again.';

        case 'network-request-failed':
          return 'Could not connect. Please check your internet connection.';

        case 'requires-recent-login':
          return 'Please sign in again before changing your password.';

        case 'user-disabled':
          return 'This account is currently unavailable.';

        default:
          return 'Something went wrong. Please try again.';
      }
    }

    return 'Something went wrong. Please try again.';
  }
}
