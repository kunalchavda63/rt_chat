import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/services/navigation/router.dart';
import 'package:rt_chat/core/utilities/utils.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomWidgets.customAnimationWrapper(
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
                    push(context, RoutesEnum.otp.path);
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
    );
  }
}
