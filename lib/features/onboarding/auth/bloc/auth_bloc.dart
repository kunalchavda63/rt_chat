import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/services/repositories/auth_repository.dart';
import 'package:rt_chat/core/services/repositories/service_locator.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  AuthBloc() : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
  }


  //Login
  Future<void> _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await getIt<AuthRepository>().signIn(email: event.email, password: event.password);
      final user = getIt<AuthRepository>().auth.currentUser;
      emit(Authenticated(user: user!));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // Register
  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await getIt<AuthRepository>().createAccount(user: event.user);

      final user = getIt<AuthRepository>().auth.currentUser;

      emit(Authenticated(user: user!));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // Log Out
  Future<void> _onSignOutRequested(
      SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await getIt<AuthRepository>().signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // Check Auth Status
  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    try {
      final user = getIt<AuthRepository>().auth.currentUser;

      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // Reset Password
  Future<void> _onForgotPasswordRequested(
      ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await getIt<AuthRepository>().sendForgotPasswordEmail(email: event.email);
      emit(AuthMessage(message: 'Password reset email sent.'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
      showErrorToast('Failed : $e');

    }
  }

}
