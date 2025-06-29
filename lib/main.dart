  import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/bloc/chat_user_bloc/chat_bloc.dart';
import 'package:rt_chat/bloc/recent_user_bloc/recent_user_cubit.dart';
import 'package:rt_chat/bloc/search_user_bloc/search_cubit.dart';
import 'package:rt_chat/bloc/theme_bloc/theme_cubit.dart';
  import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/features/onboarding/auth/bloc/auth_bloc.dart';
import 'package:rt_chat/features/onboarding/auth_sevice/suth_service.dart';
import 'package:rt_chat/features/screens/chat/chat_service.dart';
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
              BlocProvider(create: (_)=>AuthBloc(service)),
              BlocProvider(create: (_)=>ThemeCubit()),
              BlocProvider(create: (_)=>RecentUserCubit()),
              BlocProvider(create: (_)=>SearchUserCubit()),
              BlocProvider(create: (_)=>ChatBloc(ChatService(),FirebaseAuth.instance)),


            ],
            child: MyApp())));
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {

      return BlocBuilder<ThemeCubit,ThemeMode>(
        builder: (context,themeMode) {
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
      );
    }
  }
