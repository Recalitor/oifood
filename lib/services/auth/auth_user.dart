import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String? email;
  final bool isEmailVerifiedfalse;

  const AuthUser({
    required this.email,
    required this.isEmailVerifiedfalse,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email,
        isEmailVerifiedfalse: user.emailVerified,
      );
}
