import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/utilities/utils.dart';
import 'package:rt_chat/features/onboarding/auth/bloc/auth_bloc.dart';
import 'package:rt_chat/features/onboarding/auth/bloc/auth_event.dart';

import 'auth/bloc/auth_state.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  late Size size;
  late ThemeData theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);
    size = MediaQuery.of(context).size;
    theme.brightness== Brightness.light?setStatusBarLightStyle():setStatusBarDarkStyle();
  }

  @override
  Widget build(BuildContext context) {

    final textColor = theme.textTheme.bodyLarge?.color ?? AppColors.black;

    final style = BaseStyle.s17w400
        .c(textColor)
        .family(FontFamily.poppins)
        .line(0.9);

    void sentEmail() async {
      try {
        context.read<AuthBloc>().add(
          ForgotPasswordRequested(email: _emailController.text.trim())
        );
        context.pop();
      } catch (e) {
        logger.e(e.toString());
        showErrorToast("An error occurred.");
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: CustomWidgets.customAppBar(bgColor: AppColors.transparent,height: 0),
      body: BlocBuilder<AuthBloc,AuthState>(
        builder: (context,state) {
          return Form(
            key: _form,
            child: CustomWidgets.customAnimationWrapper(
              animationType: AnimationType.fade,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 500),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Background
                  CustomWidgets.customContainer(
                    h: size.height,
                    w: size.width,
                    color: theme.scaffoldBackgroundColor,
                    child: Stack(
                      children: [
                        SizedBox(height: size.height),
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.1,
                            child: CustomImageView(
                              path: AssetImages.imgBg,
                              fit: BoxFit.cover,

                              sourceType: ImageType.asset,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 50.r,
                          left: 21.r,
                          child: CustomWidgets.customCircleBackButton(
                              color: theme.primaryColor),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Column(
                    children: [
                      SizedBox(height: 50.r),
                      CustomWidgets.customAnimationWrapper(
                        animationType: AnimationType.fade,
                        curve: Curves.decelerate,
                        duration: const Duration(milliseconds: 800),
                        child: SvgPicture.asset(
                          height: 100.r,
                          width: 100.r,
                          AssetIcons.icForgot,
                          colorFilter: ColorFilter.mode(
                            textColor,
                            BlendMode.srcIn,
                          ),
                        ).padTop(50.r),
                      ),
                      CustomWidgets.customText(
                        textAlign: TextAlign.center,
                        data: AppStrings.forgotPassword,
                        style: BaseStyle.s50w400
                            .c(textColor)
                            .family(FontFamily.poppins),
                      ).padBottom(20.r),
                      CustomWidgets.customText(
                        textAlign: TextAlign.center,
                        data: AppStrings.forgotPara,
                        style: BaseStyle.s14w500
                            .c(textColor)
                            .family(FontFamily.poppins),
                      ).padH(22.r).padBottom(30.r),

                      // Email Field
                      CustomWidgets.customTextField(
                        validator: validateEmail,
                        controller: _emailController,
                        textInputType: TextInputType.emailAddress,
                        focusNode: _emailFocus,
                        fillColor: theme.scaffoldBackgroundColor,
                        filled: true,
                        label: AppStrings.email,
                        style: style,
                        labelStyle: style,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: textColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ).padH(10).padBottom(20.r),

                      // Button
                      CustomWidgets.customButton(
                        onTap: () {
                          if (_form.currentState!.validate()) {
                            sentEmail();
                          }
                        },
                        label: AppStrings.send,
                        isFullyWhite: true,
                      ).padH(15.r),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
