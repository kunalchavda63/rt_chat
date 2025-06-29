import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rt_chat/core/services/navigation/src/app_router.dart';
import 'package:rt_chat/core/services/repositories/service_locator.dart';
import 'package:rt_chat/features/onboarding/auth/bloc/auth_event.dart';
import 'package:rt_chat/features/onboarding/forgot_screen.dart';
import 'package:rt_chat/features/onboarding/register_screen.dart';

import '../../core/app_ui/app_ui.dart';
import '../../core/utilities/utils.dart';
import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final style = BaseStyle.s17w400
      .c(AppColors.hex2824)
      .family(FontFamily.poppins)
      .line(0.9);

  late Size size;
  late ThemeData theme;



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setStatusBarDarkStyle();
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
  }
 bool? hasValidateError = false;
  void _submitLogin() {
    final isValid = _form.currentState?.validate() ?? false;
    setState(() {
      hasValidateError = !isValid;
    });

    if (isValid) {
      context.read<AuthBloc>().add(
        SignInRequested(
          email: _emailController.text.trim(),
          password: _passController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomWidgets.customAppBar(
        height: 0,
        bgColor: theme.scaffoldBackgroundColor,
        bottomOpacity: 0,
        elevation: 0,

      ),
      backgroundColor: AppColors.transparent,
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {

          } else if (state is AuthError) {
            showErrorToast(state.message);
          }
        },
        builder: (context, state) {
          return state is AuthLoading
              ? Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Form(
                        key: _form,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            // Top background and welcome text
                            CustomWidgets.customContainer(
                              h: size.height,
                              w: size.width,
                              color: isDarkMode ? theme.primaryColor: theme.scaffoldBackgroundColor.withAlpha(500),
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: 0.2,
                                    child: CustomImageView(
                                      path: AssetImages.imgBg,
                                      sourceType: ImageType.asset,
                                    ),
                                  ),
                                  Positioned(
                                    left: 10,
                                    right: 10,
                                    top:
                                        hasValidateError!
                                            ? size.height / 15
                                            : size.height / 10,
                                    child: CustomAnimatedWrapper(
                                      animationType: AnimationType.fadeScale,
                                      curve: Curves.decelerate,
                                      duration: const Duration(seconds: 2),
                                      child: CustomWidgets.customText(
                                        data: AppStrings.welcomeBack,
                                        textAlign: TextAlign.center,
                                        style: BaseStyle.s50w400.c(
                                          AppColors.hex2824,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Bottom login card
                            CustomAnimatedWrapper(
                              animationType: AnimationType.fade,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.decelerate,
                              child: CustomWidgets.customContainer(
                                w: size.width,
                                color: theme.scaffoldBackgroundColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom +
                                        36.r,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      CustomWidgets.customText(
                                            data: AppStrings.login,
                                            style: BaseStyle.s23w500
                                                .family(FontFamily.poppins)
                                                .c(theme.primaryColor)
                                                .s(38),
                                          )
                                          .padTop(10)
                                          .padBottom(20.r)
                                          .padLeft(21.r),
                                      CustomWidgets.customTextField(
                                        validator: validateEmail,
                                        controller: _emailController,
                                        textInputAction: TextInputAction.next,
                                        textInputType:
                                            TextInputType.emailAddress,
                                        focusNode: _emailFocus,
                                        fillColor: theme.scaffoldBackgroundColor,
                                        filled: true,
                                        label: AppStrings.email,
                                        style: style.c(theme.primaryColor),
                                        labelStyle: style.c(theme.primaryColor),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: theme.primaryColor,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                      ).padH(10).padBottom(10.r),
                                      CustomWidgets.customTextField(
                                        validator: validatePassword,
                                        controller: _passController,
                                        textInputType:
                                            TextInputType.visiblePassword,
                                        focusNode: _passFocus,
                                        fillColor: theme.scaffoldBackgroundColor,
                                        filled: true,
                                        label: AppStrings.password,
                                        labelStyle: style.c(theme.primaryColor),
                                        style: style.c(theme.primaryColor),
                                        border: OutlinedInputBorder(
                                          borderSide: BorderSide(
                                            color: theme.primaryColor,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                      ).padH(10).padBottom(20.r),
                                      Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            getIt<AppRouter>().push(ForgotScreen());
                                          },
                                          child: CustomWidgets.customText(
                                            data: AppStrings.forgotPassword,
                                            style: style.c(theme.primaryColor),
                                          ).padBottom(20.r),
                                        ),
                                      ),
                                      CustomWidgets.customButton(
                                        label: AppStrings.login,
                                        onTap: _submitLogin,
                                      ).padH(10.r).padBottom(23.r),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          const Divider(),
                                          CustomWidgets.customContainer(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            color: theme.scaffoldBackgroundColor,
                                            child: CustomWidgets.customText(
                                              textAlign: TextAlign.center,
                                              data: AppStrings.or,
                                              style: BaseStyle.s17w400
                                                  .family(FontFamily.poppins)
                                                  .c(theme.primaryColor),
                                            ),
                                          ),
                                        ],
                                      ).padBottom(23.r),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          circleIcon(
                                            icon: AssetIcons.icGoogle,
                                          ).padRight(20.r),
                                          circleIcon(
                                            icon: AssetIcons.icFacebook,
                                          ).padRight(20.r),
                                          if (isIos)
                                            circleIcon(
                                              icon: AssetIcons.icApple,
                                            ),
                                        ],
                                      ).padBottom(20),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomWidgets.customText(
                                            data: AppStrings.doNotHaveAnAccount,
                                            style: style.c(theme.primaryColor),
                                          ).padRight(10.r),
                                          GestureDetector(
                                            onTap: () {
                                              getIt<AppRouter>().push(SignUpScreen());


                                            },
                                            child: CustomWidgets.customText(
                                              data: AppStrings.signUp,
                                              style: style.c(theme.primaryColor.withAlpha(200)),
                                            ),
                                          ),
                                        ],
                                      ).padBottom(36.r),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
        },
      ),
    );
  }

  Widget circleIcon({String? icon, VoidCallback? onTap}) {
    return CustomWidgets.customContainer(
      onTap: onTap,
      h: 60.r,
      w: 60.r,
      color: AppColors.transparent,
      boxShape: BoxShape.circle,
      border: Border.all(color: theme.primaryColor),
      alignment: Alignment.center,
      child: CustomAnimatedWrapper(
        animationType: AnimationType.fade,
        curve: Curves.ease,
        duration: const Duration(seconds: 2),
        child: SvgPicture.asset(
          icon ?? AssetIcons.icFacebook,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
