import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerifiedfalse;
  const AuthUser({required this.isEmailVerifiedfalse});

  factory AuthUser.fromFirebase(User user) =>
      AuthUser(isEmailVerifiedfalse: user.emailVerified);
}
