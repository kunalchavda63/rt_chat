import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/utilities/utils.dart';
import 'package:rt_chat/features/onboarding/auth_sevice/suth_service.dart';

import '../../core/utilities/src/extensions/logger/logger.dart';

class ForgotScreen extends ConsumerStatefulWidget {
  const ForgotScreen({super.key});

  @override
  ConsumerState<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends ConsumerState<ForgotScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
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
    void sentEmail() async {
      try {
        await provider.resetPassword(email: _emailController.text.trim());
        logger.i('Sent Link Successfully');
      } on FirebaseAuthException catch (e) {
        logger.e(e.message);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                color: AppColors.hexF8f4,
                child: Stack(
                  children: [
                    SizedBox(height: size.height),
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.08,
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
                  CustomWidgets.customAnimationWrapper(
                    animationType: AnimationType.fade,
                    curve: Curves.decelerate,
                    duration: Duration(milliseconds: 800),
                    child: SvgPicture.asset(
                      height: 150.r,
                      width: 150.r,
                      AssetIcons.icForgot,
                      colorFilter: ColorFilter.mode(
                        AppColors.hex5c23,
                        BlendMode.srcIn,
                      ),
                    ).padTop(50.r),
                  ),
                  CustomWidgets.customText(
                    data: AppStrings.forgotPassword,
                    style: BaseStyle.s50w400
                        .c(AppColors.hex5c23)
                        .family(FontFamily.signPainter),
                  ).padBottom(20.r),
                  CustomWidgets.customText(
                    textAlign: TextAlign.center,
                    data: AppStrings.forgotPara,
                    style: BaseStyle.s17w900
                        .w(200)
                        .c(AppColors.hex5c23)
                        .family(FontFamily.signPainter),
                  ).padH(22.r).padBottom(30.r),
                  CustomWidgets.customTextField(
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                    focusNode: _emailFocus,
                    fillColor: AppColors.hexF8f4,
                    filled: true,
                    label: AppStrings.email,
                    style: style,
                    labelStyle: style,
                    border: OutlinedInputBorder(
                      borderSide: BorderSide(color: AppColors.hex5c23),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ).padH(10).padBottom(20.r),
                  CustomWidgets.customButton(
                    onTap: () {
                      if (_form.currentState!.validate()) {
                        sentEmail();
                        back(context);
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
