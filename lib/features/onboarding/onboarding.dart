import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/core/services/navigation/router.dart';

import 'auth_sevice/suth_service.dart'; // your authStateProvider

class AppEntryPoint extends ConsumerWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        debugPrint('User : ${user?.email}');
        debugPrint('User : ${user?.displayName}');
        debugPrint('User : ${user?.photoURL}');
        debugPrint('User : ${user?.phoneNumber}');
        debugPrint('User : ${user?.uid}');
        // Redirect based on user auth state
        Future.microtask(() {
          if (user == null) {
            if (!context.mounted) {
              return;
            }
            context.go(RoutesEnum.login.path);
          } else {
            if (!context.mounted) {
              return;
            }
            context.go(RoutesEnum.chatScreen.path,extra: user);
          }
        });

        // While redirecting, show a splash/loading screen
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}
