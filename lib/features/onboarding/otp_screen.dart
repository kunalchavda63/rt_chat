import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/utilities/utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocus = FocusNode();
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
      body: Stack(
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
                // animationType: AnimationType.fade,
                duration: Duration(milliseconds: 800),
                curve: Curves.decelerate,
                child: SvgPicture.asset(
                  height: 150.r,
                  width: 150.r,
                  AssetIcons.icOtp,
                  colorFilter: ColorFilter.mode(
                    AppColors.hex5c23,
                    BlendMode.srcIn,
                  ),
                ).padTop(50.r),
              ),
              CustomWidgets.customText(
                data: AppStrings.otpVerification,
                style: BaseStyle.s50w400
                    .c(AppColors.hex5c23)
                    .family(FontFamily.signPainter),
              ).padBottom(20.r),
              CustomWidgets.customText(
                textAlign: TextAlign.center,
                data: "${AppStrings.enterTheOtp} kunal@gmail.com",
                style: BaseStyle.s28w900
                    .w(200)
                    .c(AppColors.hex5c23)
                    .family(FontFamily.signPainter),
              ).padH(22.r).padBottom(30.r),

              PinCodeTextField(
                textStyle: BaseStyle.s20w900
                    .c(AppColors.hex5c23)
                    .family(FontFamily.signPainter),
                appContext: context,
                length: 4,
                controller: _otpController,
                focusNode: _otpFocus,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.circle,
                  fieldHeight: 60.r,
                  fieldWidth: 60.r,
                  activeColor: AppColors.hex5c23,
                  selectedColor: AppColors.hex5c23,
                  selectedFillColor: AppColors.hex5c23,
                  inactiveFillColor: AppColors.hex5c23,
                  inactiveColor: AppColors.hex5c23,
                  activeFillColor: AppColors.hex5c23,
                ),
              ).padH(20),

              CustomWidgets.customButton(
                label: AppStrings.verify,
                onTap: () {
                  // push(context, RoutesEnum.reset.path);
                },
                isFullyWhite: true,
              ).padH(15.r).padBottom(10.r),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomWidgets.customText(
                    data: AppStrings.didNotReceivedOtp,
                    style: BaseStyle.s20w900
                        .c(AppColors.hex5c23)
                        .family(FontFamily.signPainter),
                  ),
                  CustomWidgets.customText(
                    data: AppStrings.resend,
                    style: BaseStyle.s20w900
                        .c(AppColors.hex2744)
                        .family(FontFamily.signPainter),
                  ),
                ],
              ),
            ],
          ),

          // Bottom Card
        ],
      ),
    );
  }
}
