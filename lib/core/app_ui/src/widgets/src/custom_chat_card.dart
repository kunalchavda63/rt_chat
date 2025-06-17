import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rt_chat/core/models/src/user_model/user_model.dart';

import '../../../app_ui.dart';

class CustomChatCard extends StatelessWidget {
  final UserModel? userModel;
  const CustomChatCard({super.key, this.userModel});

  @override
  Widget build(BuildContext context) {
    return CustomWidgets.customContainer(
      h: 50.r,
      borderRadius: BorderRadius.circular(20),
      path: AssetImages.imgBg,
      w: MediaQuery.of(context).size.width,
      color: AppColors.hexF8f4,
      padding: EdgeInsets.symmetric(horizontal: 10.r),
      child: Row(
        children: [
          CustomWidgets.customContainer(
            h: 40.r,
            w: 40.r,
            color: AppColors.hex5c23,
            border: Border.all(color: AppColors.hex5c23),
            boxShape: BoxShape.circle,
            child: Icon(Icons.person, color: AppColors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidgets.customText(
                data: 'Name',
                style: BaseStyle.s20w900
                    .line(1.0)
                    .c(AppColors.hex5c23)
                    .family(FontFamily.signPainter),
              ),
              CustomWidgets.customText(
                data: 'Last Msg',
                style: BaseStyle.s14w500
                    .line(1.0)
                    .c(AppColors.hex5c23)
                    .w(900)
                    .family(FontFamily.signPainter),
              ),
            ],
          ).padV(2.r).padH(5.r),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidgets.customText(
                data: 'Last Time',
                style: BaseStyle.s14w500
                    .line(1.0)
                    .c(AppColors.hex5c23)
                    .w(900)
                    .family(FontFamily.signPainter),
              ).padBottom(5.r),
              CustomWidgets.customContainer(
                h: 20.r,
                w: 20.r,
                color: AppColors.hex5c23,
                alignment: Alignment.center,
                boxShape: BoxShape.circle,
                child: CustomWidgets.customText(
                  textAlign: TextAlign.center,
                  data: '2',
                  style: BaseStyle.s10w700.c(AppColors.hexF8f4),
                ),
              ),
            ],
          ).padV(2.r).padH(5.r),
        ],
      ),
    );
  }
}
