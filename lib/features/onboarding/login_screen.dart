import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rt_chat/features/onboarding/provider/provider.dart';
import '../../core/services/navigation/router.dart';
import '../../core/utilities/utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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

  @override
  Widget build(BuildContext context) {
    bool hasValidateError = false;
    final provider = ref.watch(authServiceProvider);

    void login() async {
      try {
        await provider.signIn(
          email: _emailController.text.trim(),
          password: _passController.text.trim(),
          context: context,
        );
        if(!context.mounted){return;}
        go(context,RoutesEnum.appEntryPoint.path);
      } on FirebaseAuthException catch (e) {
        debugPrint(e.message);
      }
    }
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Form(
                key: _form,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Top background with welcome text
                    CustomWidgets.customContainer(
                      h: size.height,
                      w: size.width,
                      color: isDarkMode ? theme.primaryColor: AppColors.white.withAlpha(200),

                      child: Stack(
                        children: [
                          Opacity(
                            opacity: 0.5,
                            child: CustomImageView(
                              path: AssetImages.imgBg,
                              sourceType: ImageType.asset,
                            ),
                          ),
                          Positioned(
                            left: 10,
                            right: 10,
                            top:
                                hasValidateError
                                    ? size.height / 20
                                    : size.height / 10,
                            child: CustomAnimatedWrapper(
                              animationType: AnimationType.fadeScale,
                              curve: Curves.decelerate,
                              duration: const Duration(seconds: 2),
                              child: CustomWidgets.customText(
                                data: AppStrings.welcomeBack,
                                textAlign: TextAlign.center,
                                style: BaseStyle.s50w400.c(AppColors.hex2824),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom card with form
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
                                MediaQuery.of(context).viewInsets.bottom + 36.r,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomWidgets.customText(
                                data: AppStrings.login,
                                style: BaseStyle.s23w500
                                    .family(FontFamily.poppins)
                                    .c(theme.primaryColor)
                                    .s(38),
                              ).padTop(10).padBottom(20.r).padLeft(21.r),
                              CustomWidgets.customTextField(
                                validator: validateEmail,
                                controller: _emailController,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.emailAddress,
                                focusNode: _emailFocus,
                                fillColor: theme.scaffoldBackgroundColor,
                                filled: true,
                                label: AppStrings.email,
                                style: style.c(theme.primaryColor),
                                labelStyle: style.c(theme.primaryColor),
                                border: OutlinedInputBorder(
                                  borderSide: BorderSide(
                                    color: theme.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ).padH(10).padBottom(10.r),
                              CustomWidgets.customTextField(
                                validator: validatePassword,
                                controller: _passController,
                                textInputType: TextInputType.visiblePassword,
                                focusNode: _passFocus,
                                fillColor: theme.scaffoldBackgroundColor,
                                filled: true,
                                label: AppStrings.password,
                                style: style.c(theme.primaryColor),
                                labelStyle: style.c(theme.primaryColor),
                                border: OutlinedInputBorder(
                                  borderSide: BorderSide(
                                    color: theme.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ).padH(10).padBottom(20.r),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    push(context, RoutesEnum.forgot.path);
                                  },
                                  child: CustomWidgets.customText(
                                    data: AppStrings.forgotPassword,
                                    style: style.c(theme.primaryColor),
                                  ).padBottom(20.r),
                                ),
                              ),
                              CustomWidgets.customButton(
                                label: AppStrings.login,
                                onTap: () {
                                  final isValid =
                                      _form.currentState!.validate();
                                  setState(() {
                                    hasValidateError = !isValid;
                                  });
                                  if (isValid) {
                                    login();

                                  }
                                },
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
                                    border: Border.all(color: theme.primaryColor.withAlpha(20)),
                                    borderRadius: BorderRadius.circular(20),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  circleIcon(
                                    icon: AssetIcons.icGoogle,
                                  ).padRight(20.r),
                                  circleIcon(
                                    icon: AssetIcons.icFacebook,
                                  ).padRight(20.r),
                                  if (isIos)
                                    circleIcon(icon: AssetIcons.icApple),
                                ],
                              ).padBottom(20),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomWidgets.customText(
                                    data: AppStrings.doNotHaveAnAccount,
                                    style: style.c(theme.primaryColor),
                                  ).padRight(10.r),
                                  GestureDetector(
                                    onTap: () {
                                      context.push(RoutesEnum.register.path);
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
      border: Border.all(color: Theme.of(context).primaryColor),
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
