import 'package:rt_chat/core/app_ui/app_ui.dart';

class CustomPopupMenuButton extends StatelessWidget {
  final List<String> items;
  final AnimationStyle? animationStyle;
  final Color? boxColor;
  final Offset? offset;
  final Widget? eachChild;
  final ShapeBorder? shapeBorder;
  final PopupMenuPosition? popupMenuPosition;

  final void Function(String value) onSelected;
  final Icon icon;

  const CustomPopupMenuButton({
    super.key,
    required this.items,
    required this.onSelected,
    this.icon = const Icon(Icons.more_vert), this.animationStyle, this.boxColor, this.offset, this.eachChild, this.popupMenuPosition, this.shapeBorder,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: shapeBorder??RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      popUpAnimationStyle:animationStyle?? AnimationStyle(curve: Curves.ease,duration: Duration(milliseconds: 800)),
      onSelected: onSelected,
      position: popupMenuPosition??PopupMenuPosition.over,
      color:boxColor?? AppColors.hex2824,
      offset:offset?? Offset(-20,40),
      itemBuilder: (context) => items
          .map((item) => PopupMenuItem<String>(

        value: item,
        child: eachChild??CustomWidgets.customText(data: item,style: BaseStyle.s17w400.c(AppColors.hexEeeb)),
      ))
          .toList(),
      icon: icon,
    );
  }
}
