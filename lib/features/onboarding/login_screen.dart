import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/services/navigation/router.dart';
import 'package:rt_chat/core/utilities/utils.dart';
import 'package:rt_chat/features/onboarding/auth_sevice/suth_service.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setStatusBarDarkStyle();
    size = MediaQuery.of(context).size;
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
      } on FirebaseAuthException catch (e) {
        debugPrint(e.message);
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(backgroundColor: AppColors.hex2824),
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
                      color: AppColors.hexEeeb,
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
                        color: AppColors.hex2824,
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
                                    .c(AppColors.white)
                                    .s(38),
                              ).padTop(10).padBottom(20.r).padLeft(21.r),
                              CustomWidgets.customTextField(
                                validator: validateEmail,
                                controller: _emailController,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.emailAddress,
                                focusNode: _emailFocus,
                                fillColor: AppColors.hexEeeb,
                                filled: true,
                                label: AppStrings.email,
                                style: style,
                                labelStyle: style,
                                border: OutlinedInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.hexEeeb,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ).padH(10).padBottom(10.r),
                              CustomWidgets.customTextField(
                                validator: validatePassword,
                                controller: _passController,
                                textInputType: TextInputType.visiblePassword,
                                focusNode: _passFocus,
                                fillColor: AppColors.hexEeeb,
                                filled: true,
                                label: AppStrings.password,
                                labelStyle: style,
                                style: style,
                                border: OutlinedInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.hexEeeb,
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
                                    style: style.c(AppColors.hexEeeb),
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
                                    color: AppColors.hex2824,
                                    child: CustomWidgets.customText(
                                      textAlign: TextAlign.center,
                                      data: AppStrings.or,
                                      style: BaseStyle.s17w400
                                          .family(FontFamily.poppins)
                                          .c(AppColors.white),
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
                                    style: style.c(AppColors.hexEeeb),
                                  ).padRight(10.r),
                                  GestureDetector(
                                    onTap: () {
                                      context.push(RoutesEnum.register.path);
                                    },
                                    child: CustomWidgets.customText(
                                      data: AppStrings.signUp,
                                      style: style.c(AppColors.hexF2fd),
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
      border: Border.all(color: AppColors.hexEeeb),
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
