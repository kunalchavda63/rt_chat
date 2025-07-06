import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rt_chat/core/services/navigation/router.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Make sure Flutter engine is initialized before using any services
  WidgetsFlutterBinding.ensureInitialized();

  // Register router or other services
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());

  // Optional: Unfocus any field on first frame (not usually needed unless restoring from a state)
  WidgetsBinding.instance.addPostFrameCallback((_) {
    FocusManager.instance.primaryFocus?.unfocus();
  });
}
