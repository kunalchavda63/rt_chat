import 'package:flutter_svg/flutter_svg.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/services/navigation/router.dart';
import 'package:rt_chat/core/services/repositories/service_locator.dart';

class CustomCircleBackButton extends StatelessWidget {
  final Color? color;
  const CustomCircleBackButton({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomWidgets.customContainer(
      h: 32.r,
      w: 32.r,
      onTap: () {
        getIt<AppRouter>().pop();
      },
      border: Border.all(color: color??AppColors.hex2824),
      padding: EdgeInsets.all(8),
      color: AppColors.transparent,
      boxShape: BoxShape.circle,
      child: SvgPicture.asset(
        AssetIcons.icCutLeft,
        colorFilter: ColorFilter.mode(color??AppColors.hex2824, BlendMode.srcIn),
        height: 32.r,
        width: 32.r,
      ),
    );
  }
}
