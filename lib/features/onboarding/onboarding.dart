import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/features/screens/home_screen.dart' show HomeScreen;

import 'auth_sevice/suth_service.dart';
import 'login_screen.dart';
import 'otp_screen.dart';

class AppEntryPoint extends ConsumerWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen(); // User is not logged in
        }

        if (user.emailVerified) {
          return const HomeScreen(); // User is logged in and email is verified
        } else {
          return const OtpScreen(); // User is logged in but email is not verified
        }
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}
