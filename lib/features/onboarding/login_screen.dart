import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/services/navigation/router.dart';
import 'package:rt_chat/core/utilities/utils.dart';
import 'package:rt_chat/features/onboarding/auth_sevice/suth_service.dart';

import '../../core/utilities/src/extensions/logger/logger.dart';

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
  final style = BaseStyle.s20w900
      .c(AppColors.hex5c23)
      .family(FontFamily.signPainter)
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
    final provider = ref.watch(authServiceProvider);
    void login() async {
      try {
        await provider.signIn(
          email: _emailController.text.trim(),
          password: _passController.text.trim(),
        );
        logger.i('Login Successfully');
      } on FirebaseAuthException catch (e) {
        logger.e(e.message);
      }
    }

    return Scaffold(
      body: Form(
        key: _form,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomWidgets.customContainer(
              h: size.height,
              w: size.width,

              color: AppColors.hexF8f4,
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.08,
                    child: CustomImageView(
                      path: AssetImages.imgBg,
                      sourceType: ImageType.asset,
                    ),
                  ),
                  Positioned(
                    left: 10,
                    right: 10,
                    top: size.height / 15,
                    child: CustomAnimatedWrapper(
                      animationType: AnimationType.fadeScale,
                      curve: Curves.decelerate,
                      duration: const Duration(seconds: 2),
                      child: CustomWidgets.customText(
                        data: AppStrings.welcomeBack,
                        textAlign: TextAlign.center,
                        style: BaseStyle.s80w500.c(AppColors.hex5c23),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Card
            CustomAnimatedWrapper(
              animationType: AnimationType.fade,
              duration: const Duration(milliseconds: 200),
              curve: Curves.decelerate,
              child: CustomWidgets.customContainer(
                h: size.height / 1.5,
                w: size.width,
                color: AppColors.hex5c23,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Column(
                  children: [
                    CustomWidgets.customText(
                      data: AppStrings.loginC,
                      style: BaseStyle.s23w900
                          .family(FontFamily.signPainter)
                          .c(AppColors.white)
                          .s(38),
                    ).padTop(10).padBottom(10.r),
                    CustomWidgets.customTextField(
                      validator: validateEmail,
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                      focusNode: _emailFocus,
                      fillColor: AppColors.hexF8f4,
                      filled: true,
                      label: AppStrings.email,
                      style: style,
                      labelStyle: style,
                      border: OutlinedInputBorder(
                        borderSide: BorderSide(color: AppColors.hexF8f4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ).padH(10).padBottom(10.r),
                    CustomWidgets.customTextField(
                      validator: validatePassword,
                      // suffixIcon: SvgPicture.asset(
                      //   AssetIcons.icEye,
                      // ).padRight(10).padV(10),
                      controller: _passController,
                      textInputType: TextInputType.visiblePassword,
                      focusNode: _passFocus,
                      fillColor: AppColors.hexF8f4,
                      filled: true,
                      label: AppStrings.password,
                      labelStyle: style,
                      style: style,
                      border: OutlinedInputBorder(
                        borderSide: BorderSide(color: AppColors.hexF8f4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ).padH(10).padBottom(20.r),
                    GestureDetector(
                      onTap: () {
                        push(context, RoutesEnum.forgot.path);
                      },
                      child: CustomWidgets.customText(
                        data: AppStrings.forgotPassword,
                        style: style.c(AppColors.hexF8f4),
                      ).padBottom(20.r),
                    ),
                    CustomWidgets.customButton(
                      onTap: () {
                        if (_form.currentState!.validate()) {
                          login();
                        }
                      },
                    ).padH(10.r).padBottom(23.r),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(),
                        Positioned(child: Divider()),
                        Positioned(
                          child: CustomWidgets.customContainer(
                            h: 40,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            color: AppColors.hex5c23,
                            child: CustomWidgets.customText(
                              data: AppStrings.or,
                              style: BaseStyle.s28w900
                                  .family(FontFamily.signPainter)
                                  .c(AppColors.white),
                            ),
                          ),
                        ),
                      ],
                    ).padBottom(23.r),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        circleIcon(icon: AssetIcons.icGoogle).padRight(20.r),
                        circleIcon(icon: AssetIcons.icFacebook).padRight(20.r),
                        if (isIos) circleIcon(icon: AssetIcons.icApple),
                      ],
                    ).padBottom(20),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomWidgets.customText(
                          data: AppStrings.doNotHaveAnAccount,
                          style: style.c(AppColors.hexF8f4),
                        ).padRight(10.r),
                        GestureDetector(
                          onTap: () {
                            context.push(RoutesEnum.register.path);
                          },
                          child: CustomWidgets.customText(
                            data: AppStrings.signUp,
                            style: style.c(AppColors.hex4fc9),
                          ),
                        ),
                      ],
                    ).padBottom(
                      MediaQuery.of(context).viewPadding.bottom + 36.r,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      border: Border.all(color: AppColors.hexF8f4),
      alignment: Alignment.center,
      child: CustomAnimatedWrapper(
        animationType: AnimationType.fade,
        curve: Curves.ease,
        duration: Duration(seconds: 2),
        child: SvgPicture.asset(
          icon ?? AssetIcons.icFacebook,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
