  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/provider/theme_provider/theme_provider.dart';
import 'package:rt_chat/features/onboarding/auth/bloc/auth_bloc.dart';
import 'package:rt_chat/features/onboarding/auth_sevice/suth_service.dart';
  import 'core/services/navigation/src/app_router.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'firebase_options.dart';

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final AuthService service = AuthService();
    runApp(ProviderScope(
        child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_)=>AuthBloc(service))
            ],
            child: MyApp())));
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
