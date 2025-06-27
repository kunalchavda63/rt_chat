abstract class AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  SignInRequested({required this.email, required this.password});
}

class SignUpRequested extends AuthEvent {
  final dynamic user;
  SignUpRequested({required this.user});
}

class SignOutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  ForgotPasswordRequested({required this.email});
}
