import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/app_ui/src/widgets/custom_widgets.dart';

class CustomButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onTap;

  const CustomButton({super.key, this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomWidgets.customContainer(
      h: 50.r,
      w: size.width,
      color: AppColors.hexF8f4,
      child: CustomWidgets.customText(data: label ?? ''),
    );
  }
}
