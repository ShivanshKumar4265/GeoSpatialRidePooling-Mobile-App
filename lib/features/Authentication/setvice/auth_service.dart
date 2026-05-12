import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      // Open Google Sign In
      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      // Get Google Auth
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create Firebase Credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login to Firebase
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'User not found',
        );
      }

      // Email check
      if (user.email == null || user.email!.isEmpty) {
        await signOut();

        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'Email not found',
        );
      }

      // Verified check
      if (!user.emailVerified) {
        await signOut();

        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Email not verified',
        );
      }
      return user;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'google-signin-failed',
        message: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}