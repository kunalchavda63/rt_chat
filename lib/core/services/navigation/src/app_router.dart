import 'package:rt_chat/features/onboarding/onboarding.dart';

import 'routes.dart';

final goRouterConfig = GoRouter(
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
  ],
);
