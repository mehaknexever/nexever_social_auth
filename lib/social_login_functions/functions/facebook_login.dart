import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../login_method.dart';
import '../model/facebook.dart';

class FaceBookLogin extends LoginMethod {
  Future<(UserCredential?, dynamic)> signInwithFaceBook() async {
    var facebookAuth = FacebookAuth.instance;
    var firebaseAuth = FirebaseAuth.instance;
    try {
      final LoginResult result = await facebookAuth.login();
      var credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      print(result);

      var _res = await firebaseAuth.signInWithCredential(credential);
      var details = await getFacebookAccountDetails(result.accessToken!.token);
      _res.user!.updatePhotoURL(details.picture!.data!.url ?? '');
      return (_res, "");
    } catch (e, st) {
      print("FACEBOOK SIGN ERROR:===> $e Strack Tracee $st");
      return(null, "Something went wrong");
    }
  }

  Future<FacebookAccountData> getFacebookAccountDetails(
      String accessToken) async {
    try {
      var response = await http.get(
        Uri.parse(
            "https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=$accessToken"),
      );
      return FacebookAccountData.fromJson(jsonDecode(response.body));
    } on TimeoutException catch (e, st) {
      throw 'Time out';
    } catch (e, st) {
      rethrow;
    }
  }

  @override
  Future<(UserCredential?, dynamic)> login() async {
    // TODO: implement login
    return await signInwithFaceBook();
  }
}
