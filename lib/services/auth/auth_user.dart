import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerifiedfalse; //isEmailVerified;

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerifiedfalse,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerifiedfalse: user.emailVerified,
      );
}
