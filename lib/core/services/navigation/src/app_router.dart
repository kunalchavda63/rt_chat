import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/features/onboarding/onboarding.dart';
import 'package:rt_chat/features/screens/chat_screen.dart';
import 'package:rt_chat/features/screens/profile_setup.dart';
import 'package:rt_chat/features/screens/search_users.dart';

import '../../../../features/screens/screens.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterConfig = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RoutesEnum.appEntryPoint.path,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      name: RoutesEnum.login.name,
      path: RoutesEnum.login.path,
      pageBuilder: (_, __) => const NoTransitionPage(child: LoginScreen()),
    ),
    GoRoute(
      name: RoutesEnum.register.name,
      path: RoutesEnum.register.path,
      pageBuilder: (_, __) => const NoTransitionPage(child: SignUpScreen()),
    ),
    GoRoute(
      name: RoutesEnum.forgot.name,
      path: RoutesEnum.forgot.path,
      pageBuilder: (_, __) => const NoTransitionPage(child: ForgotScreen()),
    ),

    GoRoute(
      name: RoutesEnum.appEntryPoint.name,
      path: RoutesEnum.appEntryPoint.path,
      pageBuilder: (_, state) {
        return NoTransitionPage(child: AppEntryPoint());
      },
    ),
    StatefulShellRoute.indexedStack(
      builder:
          (context, state, navigationShell) =>
              Screens(navigationShell: navigationShell),

      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutesEnum.chatScreen.path,
              builder: (context, state) => const ChatScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutesEnum.profileSetup.path,
              builder: (context, state) => const ImageProfileUpdate(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RoutesEnum.searchUser.path,
      builder: (context, state) => const SearchUsers(),
    ),
  ],
);
