import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/utilities/src/strings.dart';

class CustomButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onTap;

  const CustomButton({super.key, this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomWidgets.customContainer(
      onTap: onTap,
      h: 50.r,
      w: size.width,
      color: AppColors.hexF792,
      border: Border.all(color: Theme.of(context).primaryColor),
      alignment: Alignment.center,
      borderRadius: BorderRadius.circular(15),
      clip: Clip.hardEdge,
      // Ensure children are clipped within borderRadius
      child: Align(
        alignment: Alignment.center,
        child: CustomWidgets.customText(
          data: label ?? AppStrings.loginC,
          style: BaseStyle.s28w400
              .w(400)
              .c(AppColors.hex2824)
              .family(FontFamily.poppins),
        ),
      ),
    );
  }
}
