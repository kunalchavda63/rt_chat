import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/utilities/src/extensions/logger/logger.dart';
import 'package:rt_chat/core/utilities/utils.dart';
import 'package:rt_chat/features/onboarding/auth_sevice/suth_service.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _userIdFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _confirmPassFocus = FocusNode();
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
    void register() async {
      try {
        await provider.createAccount(
          email: _emailController.text.trim(),
          password: _passController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        logger.e(e.message);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    top: 50.r,
                    left: 21.r,
                    child: CustomWidgets.customCircleBackButton(),
                  ),
                ],
              ),
            ),

            // Bottom Card
            CustomWidgets.customAnimationWrapper(
              animationType: AnimationType.fade,
              duration: const Duration(seconds: 2),
              curve: Curves.decelerate,
              child: CustomWidgets.customContainer(
                h: size.height / 1.17,
                w: size.width,
                color: AppColors.hex5c23,
                padding: EdgeInsets.symmetric(horizontal: 10.r),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomWidgets.customAnimationWrapper(
                      animationType: AnimationType.slideFromLeft,
                      duration: Duration(seconds: 2),
                      curve: Curves.decelerate,
                      child: CustomWidgets.customText(
                        data: AppStrings.signUp,
                        style: BaseStyle.s50w400
                            .c(AppColors.hexF8f4)
                            .family(FontFamily.signPainter),
                      ).padLeft(10.r),
                    ).padBottom(50.r),
                    CustomWidgets.customTextField(
                      controller: _userIdController,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                      focusNode: _userIdFocus,
                      fillColor: AppColors.hexF8f4,
                      filled: true,
                      label: AppStrings.userid,
                      style: style,
                      labelStyle: style,
                      border: OutlinedInputBorder(
                        borderSide: BorderSide(color: AppColors.hexF8f4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ).padH(10).padBottom(20.r),
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
                    ).padH(10).padBottom(20.r),
                    CustomWidgets.customTextField(
                      validator: validatePassword,
                      controller: _passController,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                      focusNode: _passFocus,
                      fillColor: AppColors.hexF8f4,
                      filled: true,
                      label: AppStrings.password,
                      style: style,
                      labelStyle: style,
                      border: OutlinedInputBorder(
                        borderSide: BorderSide(color: AppColors.hexF8f4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ).padH(10).padBottom(20.r),
                    CustomWidgets.customTextField(
                      validator:
                          (val) => confirmPasswordValidator(
                            val,
                            _passController.text.trim(),
                          ),
                      controller: _confirmPassController,
                      textInputType: TextInputType.visiblePassword,
                      focusNode: _confirmPassFocus,
                      fillColor: AppColors.hexF8f4,
                      filled: true,
                      label: AppStrings.confirmPassword,
                      style: style,
                      labelStyle: style,
                      border: OutlinedInputBorder(
                        borderSide: BorderSide(color: AppColors.hexF8f4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ).padH(10).padBottom(20.r),
                    CustomWidgets.customButton(
                      onTap: () {
                        if (_form.currentState!.validate()) {
                          register();
                          logger.i('Created Succefully');
                        }
                      },
                      label: AppStrings.createNewAccount,
                    ).padH(10.r),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomWidgets.customText(
                          data: AppStrings.alreadyHaveAnAccount,
                          style: style.c(AppColors.hexF8f4),
                        ).padRight(10.r),
                        GestureDetector(
                          onTap: () {
                            back(context);
                          },
                          child: CustomWidgets.customText(
                            data: AppStrings.login,
                            style: style.c(AppColors.hex4fc9),
                          ),
                        ),
                      ],
                    ).padBottom(
                      MediaQuery.of(context).viewPadding.bottom + 47.r,
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
}
