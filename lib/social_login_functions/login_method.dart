import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginMethod {
 Future<(UserCredential?, dynamic)> login();
}