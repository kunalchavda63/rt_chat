import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/utilities/utils.dart';
import 'package:rt_chat/features/onboarding/auth_sevice/suth_service.dart';

class ForgotScreen extends ConsumerStatefulWidget {
  const ForgotScreen({super.key});

  @override
  ConsumerState<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends ConsumerState<ForgotScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
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
    void sentEmail() async {
      try {
        await provider.resetPassword(
          email: _emailController.text.trim(),
          context: context,
        );
      } catch (e) {
        logger.e(e.toString());
        showErrorToast("An error occurred.");
        // Don't go back here either
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Form(
        key: _form,
        child: CustomWidgets.customAnimationWrapper(
          animationType: AnimationType.fade,
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 500),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CustomWidgets.customContainer(
                h: size.height,
                w: size.width,
                color: AppColors.hexEeeb,
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
                      child: CustomWidgets.customCircleBackButton(),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 50.r),
                  CustomWidgets.customAnimationWrapper(
                    animationType: AnimationType.fade,
                    curve: Curves.decelerate,
                    duration: Duration(milliseconds: 800),
                    child: SvgPicture.asset(
                      height: 100.r,
                      width: 100.r,
                      AssetIcons.icForgot,
                      colorFilter: ColorFilter.mode(
                        AppColors.hex2824,
                        BlendMode.srcIn,
                      ),
                    ).padTop(50.r),
                  ),
                  CustomWidgets.customText(
                    textAlign: TextAlign.center,
                    data: AppStrings.forgotPassword,
                    style: BaseStyle.s50w400
                        .c(AppColors.hex2824)
                        .family(FontFamily.poppins),
                  ).padBottom(20.r),
                  CustomWidgets.customText(
                    textAlign: TextAlign.center,
                    data: AppStrings.forgotPara,
                    style: BaseStyle.s14w500
                        .c(AppColors.hex2824)
                        .family(FontFamily.poppins),
                  ).padH(22.r).padBottom(30.r),
                  CustomWidgets.customTextField(
                    validator: validateEmail,
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                    focusNode: _emailFocus,
                    fillColor: AppColors.hexEeeb,
                    filled: true,
                    label: AppStrings.email,
                    style: style,
                    labelStyle: style,
                    border: OutlinedInputBorder(
                      borderSide: BorderSide(color: AppColors.hex2824),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ).padH(10).padBottom(20.r),
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

              // Bottom Card
            ],
          ),
        ),
      ),
    );
  }
}
