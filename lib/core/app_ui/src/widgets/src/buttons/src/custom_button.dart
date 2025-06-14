import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/utilities/src/strings.dart';

class CustomButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onTap;
  final bool? isFullyWhite;

  const CustomButton({
    super.key,
    this.label,
    this.onTap,
    this.isFullyWhite = false,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomWidgets.customContainer(
      onTap: onTap,
      h: 50.r,
      w: size.width,
      color: AppColors.hexF8f4,
      border: Border.all(
        color: isFullyWhite == true ? AppColors.hex5c23 : AppColors.transparent,
      ),
      alignment: Alignment.center,
      borderRadius: BorderRadius.circular(15),
      clip: Clip.hardEdge,
      // Ensure children are clipped within borderRadius
      child: Stack(
        fit: StackFit.expand, // Expands children to fill the container
        children: [
          if (isFullyWhite == false)
            Opacity(
              opacity: 0.08,
              child: CustomWidgets.customImageView(
                path: AssetImages.imgBg,
                fit: BoxFit.cover, // Make image cover fully
              ),
            ),
          Align(
            alignment: Alignment.center,
            child: CustomWidgets.customText(
              data: label ?? AppStrings.loginC,
              style: BaseStyle.s28w900
                  .w(400)
                  .c(AppColors.hex5c23)
                  .family(FontFamily.signPainter),
            ),
          ),
        ],
      ),
    );
  }
}
