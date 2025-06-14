import 'routes.dart';

final goRouterConfig = GoRouter(
  initialLocation: RoutesEnum.login.path,
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
      name: RoutesEnum.otp.name,
      path: RoutesEnum.otp.path,
      pageBuilder: (_, __) => const NoTransitionPage(child: OtpScreen()),
    ),
    GoRoute(
      name: RoutesEnum.reset.name,
      path: RoutesEnum.reset.path,
      pageBuilder: (_, __) => const NoTransitionPage(child: ResetScreen()),
    ),
  ],
);
