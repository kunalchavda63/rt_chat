import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/core/models/src/user_model/user_model.dart';
import 'package:rt_chat/core/utilities/utils.dart';
import 'package:rt_chat/features/onboarding/provider/provider.dart';
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

  late Size size;
  late ThemeData theme;
  late bool isDarkMode;
  late Color bgColor;
  late Color textColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setStatusBarDarkStyle();
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    isDarkMode = theme.brightness == Brightness.dark;
    bgColor = isDarkMode ? AppColors.hex2824 : AppColors.hexEeeb;
    textColor = isDarkMode ? AppColors.hexEeeb : AppColors.hex2824;
  }

  @override
  Widget build(BuildContext context) {
    final style = BaseStyle.s17w400.c(textColor).family(FontFamily.poppins).line(0.9);
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
          go(context, RoutesEnum.appEntryPoint.path);
        }
      } on FirebaseAuthException catch (e) {
        debugPrint(e.message);
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: CustomWidgets.customAppBar(
        height: 0,
        bgColor: bgColor,
        bottomOpacity: 0,
        elevation: 0,
      ),
      body: Form(
        key: _form,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomWidgets.customContainer(
              h: size.height,
              w: size.width,
              color: theme.brightness == Brightness.light ? AppColors.hex7777.withAlpha(20):theme.primaryColor,
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
            CustomWidgets.customAnimationWrapper(
              animationType: AnimationType.fade,
              duration: const Duration(seconds: 2),
              curve: Curves.decelerate,
              child: CustomWidgets.customContainer(
                h: size.height / 1.17,
                w: size.width,
                color: bgColor,
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
                      style: BaseStyle.s50w400.c(textColor).family(FontFamily.poppins),
                    ).padLeft(10.r).padBottom(50.r),
                    buildField(_userIdController, _userIdFocus, AppStrings.userid, style),
                    buildField(_emailController, _emailFocus, AppStrings.email, style, validator: validateEmail),
                    buildField(_passController, _passFocus, AppStrings.password, style, validator: validatePassword),
                    buildField(
                      _confirmPassController,
                      _confirmPassFocus,
                      AppStrings.confirmPassword,
                      style,
                      validator: (val) => confirmPasswordValidator(val, _passController.text.trim()),
                    ),
                    CustomWidgets.customButton(
                      onTap: () {
                        if (_form.currentState!.validate()) {
                          register();
                        }
                      },
                      label: AppStrings.createNewAccount,
                    ).padH(10.r),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomWidgets.customText(
                          data: AppStrings.alreadyHaveAnAccount,
                          style: style,
                        ).padRight(10.r),
                        GestureDetector(
                          onTap: () => back(context),
                          child: CustomWidgets.customText(
                            data: AppStrings.login,
                            style: style.c(AppColors.hex7777),
                          ),
                        ),
                      ],
                    ).padBottom(MediaQuery.of(context).viewPadding.bottom + 47.r),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(
      TextEditingController controller,
      FocusNode focusNode,
      String label,
      TextStyle style, {
        String? Function(String?)? validator,
      }) {
    return CustomWidgets.customTextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.text,
      fillColor: bgColor,
      filled: true,
      label: label,
      style: style,
      labelStyle: style,
      validator: validator,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: textColor),
        borderRadius: BorderRadius.circular(15),
      ),
    ).padH(10).padBottom(20.r);
  }
}
