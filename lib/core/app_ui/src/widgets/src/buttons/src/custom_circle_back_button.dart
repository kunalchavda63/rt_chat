import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';

class CustomCircleBackButton extends StatelessWidget {
  const CustomCircleBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomWidgets.customContainer(
      h: 32,
      w: 32,
      onTap: () {
        context.pop();
      },
      border: Border.all(color: AppColors.hex5c23),
      padding: EdgeInsets.all(8),
      color: AppColors.transparent,
      boxShape: BoxShape.circle,
      child: SvgPicture.asset(
        AssetIcons.icCutLeft,

        colorFilter: ColorFilter.mode(AppColors.hex5c23, BlendMode.srcIn),
        height: 32,
        width: 32,
      ),
    );
  }
}
