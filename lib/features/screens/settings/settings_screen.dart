import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_chat/core/services/repositories/service_locator.dart';
import 'package:rt_chat/core/utilities/src/strings.dart';
import 'package:rt_chat/features/onboarding/onboarding.dart';

import '../../../core/app_ui/app_ui.dart';
import '../../../core/services/navigation/src/app_router.dart';
import '../../onboarding/auth/bloc/auth_bloc.dart';
import '../../onboarding/auth/bloc/auth_event.dart';
import '../../onboarding/auth/bloc/auth_state.dart';

class SettingsScreen extends StatelessWidget {
  final User? user;

  const SettingsScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          getIt<AppRouter>().pushReplacement(AppEntryPoint());
        } else if (state is AuthError) {
          showErrorToast("Logout Failed: ${state.message}");
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            CustomWidgets.customContainer(
              onTap: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
              h: 60.r,
              w: MediaQuery.of(context).size.width,
              color: AppColors.hex2824.withAlpha(10),
              padding: EdgeInsets.symmetric(horizontal: 20.r),
              alignment: Alignment.center,
              borderRadius: BorderRadius.circular(20.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomWidgets.customCircleIcon(
                    h: 20.r,
                    w: 20.r,
                    iconData: Icons.logout_outlined,
                    iconColor: Colors.red,
                  ).padRight(20.r),
                  CustomWidgets.customText(
                    data: AppStrings.logout,
                    style: BaseStyle.s17w400.c(AppColors.hex7777),
                  ),
                ],
              ),
            ).padH(20.r),
          ],
        ),
      ),
    );
  }
}
