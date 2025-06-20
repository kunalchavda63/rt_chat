import 'package:rt_chat/core/app_ui/app_ui.dart';

class CustomPopupMenuButton extends StatelessWidget {
  final List<String> items;
  final void Function(String value) onSelected;
  final Icon icon;

  const CustomPopupMenuButton({
    super.key,
    required this.items,
    required this.onSelected,
    this.icon = const Icon(Icons.more_vert),
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      popUpAnimationStyle: AnimationStyle(curve: Curves.ease,duration: Duration(milliseconds: 800)),
      onSelected: onSelected,

      position: PopupMenuPosition.over,
      color: AppColors.hex2824,
      offset: Offset(-20,40),
      itemBuilder: (context) => items
          .map((item) => PopupMenuItem<String>(

        value: item,
        child: CustomWidgets.customText(data: item,style: BaseStyle.s17w400.c(AppColors.hexEeeb)),
      ))
          .toList(),
      icon: icon,
    );
  }
}
