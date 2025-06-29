import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_chat/core/services/navigation/src/app_router.dart';
import 'package:rt_chat/core/services/repositories/service_locator.dart';
import 'package:rt_chat/features/onboarding/login_screen.dart';

import '../../core/app_ui/app_ui.dart';
import '../screens/screens.dart';
import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_event.dart';
import 'auth/bloc/auth_state.dart';

class AppEntryPoint extends StatefulWidget {
  const AppEntryPoint({super.key});

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  @override
  void initState() {
    super.initState();
    // Trigger auth check when app starts
    context.read<AuthBloc>().add(CheckAuthStatus());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is Authenticated || current is Unauthenticated,
      listener: (context, state) {
        if (state is Authenticated) {
          getIt<AppRouter>().pushReplacement(Screens());
        } else if (state is Unauthenticated) {
          getIt<AppRouter>().push(LoginScreen());

        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading || state is AuthInitial) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (state is AuthError) {
            return Scaffold(body: Center(child: Text('Error: ${state.message}')));
          }
          // While listener is handling navigation, keep splash
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
