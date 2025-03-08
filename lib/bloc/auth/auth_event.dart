import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final User? user;

  AuthUserChanged(this.user);
}
