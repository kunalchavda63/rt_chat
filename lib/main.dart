  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/provider/theme_provider/theme_provider.dart';
  import 'core/services/navigation/src/app_router.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'firebase_options.dart';

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    runApp(ProviderScope(child: MyApp()));
  }

  class MyApp extends ConsumerWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final themeMode = ref.watch(themeProvider);

      return ScreenUtilInit(
        designSize: Size(375, 812),
        builder: (context, _) {
          return MaterialApp.router(
            title: 'RT Chat',
           themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            debugShowCheckedModeBanner: false,
            routerConfig: goRouterConfig,
          );
        },
      );
    }
  }
