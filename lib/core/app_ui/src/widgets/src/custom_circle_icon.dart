import '../../../app_ui.dart';

class CustomCircleIcon extends StatelessWidget {
  final double? h;
  final double? w;
  final Border? border;
  final Color? bgColor;
  final IconData iconData;
  final double? iconSize;
  final Color? iconColor;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const CustomCircleIcon({
    super.key,
    this.h,
    this.w,
    required this.iconData,
    required this.iconSize,
    this.iconColor,
    this.border,
    this.bgColor,
    this.onTap, this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomWidgets.customContainer(
      onTap: onTap,
      h: h,
      w: w,
      padding: padding??EdgeInsets.all(8.r),
      boxShape: BoxShape.circle,
      border: border,
      color: bgColor,
      child: Icon(iconData, color: iconColor, size: iconSize),
    );
  }
}
