import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/bloc/chat_user_bloc/chat_bloc.dart';
import 'package:rt_chat/bloc/recent_user_bloc/recent_user_cubit.dart';
import 'package:rt_chat/bloc/search_user_bloc/search_cubit.dart';
import 'package:rt_chat/bloc/theme_bloc/theme_cubit.dart';
  import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/services/repositories/auth_repository.dart';
import 'package:rt_chat/features/onboarding/auth/bloc/auth_bloc.dart';
import 'package:rt_chat/features/onboarding/onboarding.dart';
import 'package:rt_chat/features/screens/chat/chat_service.dart';
import 'package:rt_chat/features/screens/screens.dart';
  import 'core/services/navigation/src/app_router.dart';
  import 'core/services/repositories/service_locator.dart';

  Future<void> main() async {
await setupServiceLocator();
    runApp(ProviderScope(
        child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_)=>AuthBloc()),
              BlocProvider(create: (_)=>ThemeCubit()),
              BlocProvider(create: (_)=>RecentUserCubit()),
              BlocProvider(create: (_)=>SearchUserCubit()),
              BlocProvider(create: (_)=>NavigationCubit()),
              BlocProvider(create: (_)=>ChatBloc(ChatService())),


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
              return MaterialApp(
                title: 'RT Chat',
                themeMode: themeMode,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                debugShowCheckedModeBanner: false,
                navigatorKey: getIt<AppRouter>().navigatorKey,
                home: AppEntryPoint(),
              );
            },
          );
        }
      );
    }
  }
