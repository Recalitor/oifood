import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerifiedfalse;
  const AuthUser(this.isEmailVerifiedfalse);

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
