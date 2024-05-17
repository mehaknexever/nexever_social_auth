import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../login_method.dart';

class AppleLogin extends LoginMethod {
  Future<(UserCredential?, dynamic)> singInWithApple() async {
    var firebaseAuth = FirebaseAuth.instance;
    try {
      var redirectURL =
          'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple';
      var clientID = 'de.lunaone.flutter.signinwithappleexample.service';
      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
              clientId: clientID, redirectUri: Uri.parse(redirectURL)));
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );
      var _res = await firebaseAuth.signInWithCredential(credential);

      return (_res, "");
    } catch (e, st) {
      print("APPLE SIGN ERROR:===> $e Strack Tracee $st");
      return(null, "Something went wrong");
    }
  }

  @override
  Future<(UserCredential?, dynamic)> login() async {
    // TODO: implement login
    return await singInWithApple();
  }
}
