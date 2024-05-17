import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nexever_social_auth/social_login_functions/app_logs.dart';

import '../login_method.dart';

class GoogleLogin extends LoginMethod {
  var firebaseAuth = FirebaseAuth.instance;

  Future<(UserCredential?, dynamic)> signInWithGoogle() async {
    // GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      var data = await googleAccountCall();
      var res = await firebaseDataCall(data.$1, data.$2);
      // var googleUser = await googleSignIn.signIn();
      // GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      // print("EMAIL ====>>>>> ${googleUser.email}");
      // final AuthCredential credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );
      // var _res = await firebaseAuth.signInWithCredential(credential);
      // _res.user?.updateDisplayName(googleUser.displayName ?? '');
      // _res.user?.verifyBeforeUpdateEmail(googleUser.email ?? "");
      // _res.user?.updatePhotoURL(googleUser.photoUrl ?? "");
      // if (_res.user?.email == null) {
      //   var _res = await firebaseAuth.signInWithCredential(credential);
      //   _res.user?.verifyBeforeUpdateEmail(googleUser.email ?? "");
      // }
      return (res, "");
    } catch (error, st) {
      logError(error: error.toString(), stackTrace: st, text: 'Google Login');
      return (null, error);
    }
  }

  Future<(AuthCredential, GoogleSignInAccount)> googleAccountCall() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      var googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      print("EMAIL ====>>>>> ${googleUser.email}");
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return (credential, googleUser);
    } catch (error, st) {
      logError(error: error.toString(), stackTrace: st, text: 'Google Login');
      throw "Unable to connect with google";
    }
  }

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

  @override
  Future<(UserCredential?, dynamic)> login() async {
    // TODO: implement login
    return await signInWithGoogle();
  }
}


// Future<(UserCredential, dynamic)> signInWithGoogle() async {
//   var firebaseAuth = FirebaseAuth.instance;
//   GoogleSignIn googleSignIn = GoogleSignIn(
//     scopes: <String>[
//       'email',
//       'https://www.googleapis.com/auth/contacts.readonly',
//     ],
//   );
//   try {
//     var googleUser = await googleSignIn.signIn();
//     GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
//     print("EMAIL ====>>>>> ${googleUser.email}");
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//     var _res = await firebaseAuth.signInWithCredential(credential);
//     _res.user?.updateDisplayName(googleUser.displayName ?? '');
//     _res.user?.verifyBeforeUpdateEmail(googleUser.email ?? "");
//     _res.user?.updatePhotoURL(googleUser.photoUrl ?? "");
//     if (_res.user?.email == null) {
//       var _res = await firebaseAuth.signInWithCredential(credential);
//       _res.user?.verifyBeforeUpdateEmail(googleUser.email ?? "");
//     }
//     return (_res,"");
//
//   } catch (error, st) {
//     print("GOOGLE SIGN ERROR:===> $error Strack Tracee $st");
//     throw error.toString();
//   }
//
// }
