import 'package:firebase_auth/firebase_auth.dart';

 class LoginState {
  success(UserCredential creds, String loginType){}
  error(var error){}
}