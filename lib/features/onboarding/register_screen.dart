
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/models/src/user_model/user_model.dart';
import 'package:rt_chat/core/utilities/utils.dart';
import 'package:rt_chat/features/onboarding/auth/bloc/auth_event.dart';

import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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

  void _submitForm() {
    final UserModel userModel = UserModel(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      displayName: _userIdController.text.trim(),

    );
    if (_form.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        SignUpRequested(
          user: userModel
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: CustomWidgets.customAppBar(
        height: 0,
        bgColor: bgColor,
        bottomOpacity: 0,
        elevation: 0,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            showSuccessToast("Account created successfully");
            Navigator.of(context).pop(); // Or push to login/home
          } else if (state is AuthError) {
            showErrorToast(state.message);
          }
        },
        builder: (context, state) {
          return state is AuthLoading?
          Center(
            child: CircularProgressIndicator(),
          )
              :
          Form(
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

                // Bottom Card
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
                          style: BaseStyle.s50w400
                              .c(textColor)
                              .family(FontFamily.poppins),
                        ).padLeft(10.r).padBottom(50.r),

                        // USER ID
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
                          onTap: _submitForm,
                          label: AppStrings.createNewAccount,
                        ).padH(10.r),

                        const Spacer(),

                        // Already have account? LOGIN
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomWidgets.customText(
                              data: AppStrings.alreadyHaveAnAccount,
                              style: style.c(textColor),
                            ).padRight(10.r),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: CustomWidgets.customText(
                                data: AppStrings.login,
                                style: style.c(isDarkMode?AppColors.hex4fc9:textColor),
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
          );
        },
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
