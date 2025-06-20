import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/models/src/user_model/user_model.dart';
import 'package:rt_chat/core/utilities/utils.dart';
import 'package:rt_chat/features/onboarding/auth_sevice/suth_service.dart';

import '../../core/services/navigation/router.dart';

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
    final provider = ref.watch(authServiceProvider);
    void register() async {
      try {
        final credential = await provider.createAccount(
          context: context,
          user: UserModel(
            email: _emailController.text.trim(),
            password: _passController.text.trim(),
            displayName: _userIdController.text.trim(),
          ),
        );

        if (credential != null && context.mounted) {
          go(context, RoutesEnum.appEntryPoint.path); // ✅ Only navigate if success
        }
      } on FirebaseAuthException catch (e) {
        debugPrint(e.message);
      }
    }


    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(backgroundColor: AppColors.hex2824),
      ),

      body: Form(
        key: _form,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomWidgets.customContainer(
              h: size.height,
              w: size.width,
              color: AppColors.hexEeeb,
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
                color: AppColors.hex2824,
                padding: EdgeInsets.symmetric(horizontal: 10.r),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomWidgets.customText(
                      data: AppStrings.signUp,
                      style: BaseStyle.s50w400
                          .c(AppColors.hexEeeb)
                          .family(FontFamily.poppins),
                    ).padLeft(10.r).padBottom(50.r),
                    CustomWidgets.customTextField(
                      controller: _userIdController,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      textInputType: TextInputType.emailAddress,
                      focusNode: _userIdFocus,
                      fillColor: AppColors.hexEeeb,
                      filled: true,
                      label: AppStrings.userid,
                      style: style,
                      labelStyle: style,
                      border: OutlinedInputBorder(
                        borderSide: BorderSide(color: AppColors.hexEeeb),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ).padH(10).padBottom(20.r),
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
                        borderSide: BorderSide(color: AppColors.hexEeeb),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ).padH(10).padBottom(20.r),
                    CustomWidgets.customTextField(
                      validator: validatePassword,
                      controller: _passController,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                      focusNode: _passFocus,
                      fillColor: AppColors.hexEeeb,
                      filled: true,
                      label: AppStrings.password,
                      style: style,
                      labelStyle: style,
                      border: OutlinedInputBorder(
                        borderSide: BorderSide(color: AppColors.hexEeeb),
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
                      fillColor: AppColors.hexEeeb,
                      filled: true,
                      label: AppStrings.confirmPassword,
                      style: style,
                      labelStyle: style,
                      border: OutlinedInputBorder(
                        borderSide: BorderSide(color: AppColors.hexEeeb),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ).padH(10).padBottom(20.r),
                    CustomWidgets.customButton(
                      onTap: () {
                        if (_form.currentState!.validate()) {
                          register();
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
                          style: style.c(AppColors.hexEeeb),
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
