import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nexever_social_auth/social_login_functions/app_logs.dart';
import '../login_method.dart';

/// A class that implements [LoginMethod] to handle Google login.
class GoogleLogin extends LoginMethod {
  /// An instance of [FirebaseAuth] to handle authentication with Firebase.
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  /// Signs in with Google and returns a [Future] containing a tuple.
  ///
  /// The tuple contains:
  /// - [UserCredential?]: The credentials of the user if the login was successful, or `null` if it failed.
  /// - [dynamic]: The error if the login failed, or an empty string if it succeeded.
  Future<(UserCredential?, dynamic)> signInWithGoogle() async {
    try {
      var data = await googleAccountCall();
      var res = await firebaseDataCall(data.$1, data.$2);
      return (res, "");
    } catch (error, st) {
      logError(error: error.toString(), stackTrace: st, text: 'Google Login');
      return (null, error);
    }
  }

  /// Calls Google sign-in and returns a [Future] containing a tuple.
  ///
  /// The tuple contains:
  /// - [AuthCredential]: The authentication credentials.
  /// - [GoogleSignInAccount]: The Google account information.
  ///
  /// Throws an error if unable to connect with Google.
  Future<(AuthCredential, GoogleSignInAccount)> googleAccountCall() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
      var googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return (credential, googleUser);
    } catch (error, st) {
      logError(error: error.toString(), stackTrace: st, text: 'Google Login');
      throw "Unable to connect with Google";
    }
  }

  /// Calls Firebase to sign in with the provided credentials and returns a [Future] containing [UserCredential].
  ///
  /// Updates the user's display name, email, and photo URL with the Google account information.
  ///
  /// Throws an error if something goes wrong during the Firebase sign-in.
  Future<UserCredential> firebaseDataCall(
      AuthCredential credential, GoogleSignInAccount googleUser) async {
    try {
      var _res = await firebaseAuth.signInWithCredential(credential);
      _res.user?.updateDisplayName(googleUser.displayName ?? '');
      _res.user?.verifyBeforeUpdateEmail(googleUser.email ?? "");
      _res.user?.updatePhotoURL(googleUser.photoUrl ?? "");
      if (_res.user?.email == null) {
        var _res = await firebaseAuth.signInWithCredential(credential);
        _res.user?.verifyBeforeUpdateEmail(googleUser.email ?? "");
      }
      return _res;
    } catch (error, st) {
      logError(error: error.toString(), stackTrace: st, text: 'Google Login');
      throw "Something went wrong";
    }
  }

  /// Implements the [login] method from [LoginMethod].
  ///
  /// Calls [signInWithGoogle] to handle the Google login process.
  @override
  Future<(UserCredential?, dynamic)> login() async {
    return await signInWithGoogle();
  }
}
