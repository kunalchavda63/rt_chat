import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/utilities/utils.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final TextEditingController _passController = TextEditingController();
  final FocusNode _passFocus = FocusNode();
  final TextEditingController _confirmPassController = TextEditingController();
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
              SvgPicture.asset(
                height: 150.r,
                width: 150.r,
                AssetIcons.icForgot,
                colorFilter: ColorFilter.mode(
                  AppColors.hex5c23,
                  BlendMode.srcIn,
                ),
              ).padTop(50.r),
              CustomWidgets.customText(
                data: AppStrings.resetPassword,
                style: BaseStyle.s50w400
                    .c(AppColors.hex5c23)
                    .family(FontFamily.signPainter),
              ).padBottom(20.r),
              CustomWidgets.customTextField(
                controller: _passController,
                textInputType: TextInputType.visiblePassword,
                focusNode: _passFocus,
                fillColor: AppColors.hexF8f4,
                filled: true,
                label: AppStrings.password,
                style: style,
                labelStyle: style,
                border: OutlinedInputBorder(
                  borderSide: BorderSide(color: AppColors.hex5c23),
                  borderRadius: BorderRadius.circular(15),
                ),
              ).padH(10).padBottom(20.r),
              CustomWidgets.customTextField(
                controller: _confirmPassController,
                textInputType: TextInputType.visiblePassword,
                focusNode: _confirmPassFocus,
                fillColor: AppColors.hexF8f4,
                filled: true,
                label: AppStrings.confirmPassword,
                style: style,
                labelStyle: style,
                border: OutlinedInputBorder(
                  borderSide: BorderSide(color: AppColors.hex5c23),
                  borderRadius: BorderRadius.circular(15),
                ),
              ).padH(10).padBottom(20.r),
              CustomWidgets.customButton(
                label: AppStrings.submit,
                isFullyWhite: true,
              ).padH(15.r),
            ],
          ),

          // Bottom Card
        ],
      ),
    );
  }
}
