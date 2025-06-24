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
    this.isFullyWhite = true,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomWidgets.customContainer(
      onTap: onTap,
      h: 50.r,
      w: size.width,
      color: AppColors.hexEeeb,
      border: Border.all(
        color: Theme.of(context).primaryColor,
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
              opacity: 0.2,
              child: CustomWidgets.customImageView(
                path: AssetImages.imgBg,
                fit: BoxFit.cover, // Make image cover fully
              ),
            ),
          Align(
            alignment: Alignment.center,
            child: CustomWidgets.customText(
              data: label ?? AppStrings.loginC,
              style: BaseStyle.s28w400
                  .w(400)
                  .c(AppColors.hex2824)
                  .family(FontFamily.poppins),
            ),
          ),
        ],
      ),
    );
  }
}
