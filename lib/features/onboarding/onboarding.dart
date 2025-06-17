import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/features/screens/home_screen.dart';

import '../../core/app_ui/app_ui.dart';
import 'auth_sevice/suth_service.dart';
import 'login_screen.dart';

class AppEntryPoint extends ConsumerWidget {
  final User? user;
  const AppEntryPoint({this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (streamUser) {
        // Use the user passed via route if stream is still null
        final effectiveUser = streamUser ?? user;

        if (effectiveUser == null) {
          return const LoginScreen(); // Not logged in
        }

        return HomeScreen(user: effectiveUser); // Logged in
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}
