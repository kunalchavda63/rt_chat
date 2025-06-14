import '../../../../features/onboarding/onboarding_screen.dart';
import 'routes.dart';

final goRouterConfig = GoRouter(
  initialLocation: RoutesEnum.onboard.path,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      name: RoutesEnum.onboard.name,
      path: RoutesEnum.onboard.path,
      pageBuilder: (_, __) => const NoTransitionPage(child: OnboardingScreen()),
    ),
  ],
);
