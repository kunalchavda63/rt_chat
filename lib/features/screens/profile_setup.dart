import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/app_ui/src/widgets/custom_widgets.dart';
import 'package:rt_chat/core/utilities/src/strings.dart';

import '../onboarding/auth_sevice/suth_service.dart';

class ImageProfileUpdate extends ConsumerStatefulWidget {
  const ImageProfileUpdate({super.key});

  @override
  ConsumerState<ImageProfileUpdate> createState() => _ImageProfileUpdateState();
}

class _ImageProfileUpdateState extends ConsumerState<ImageProfileUpdate> {

  @override
  Widget build(BuildContext context) {
     final provider=  ref.watch(authServiceProvider);
     final user = provider.currentUser;
     String? photo = user?.photoURL;

    return Scaffold(
      backgroundColor: AppColors.hexEeeb,
      appBar: CustomWidgets.customAppBar(
        isCenterTitle: false,
        autoImplyLeading: false,
        leading: CustomWidgets.customCircleBackButton(color: AppColors.hexEeeb).padLeft(25.r),
        bgColor: AppColors.hex2824,
          title: CustomWidgets.customText(data: 'Account Setup',style: BaseStyle.s17w400.c(AppColors.hexEeeb),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Stack(
              children: [
                CustomWidgets.customContainer(
                  h: 200.r,
                  w: 200.r,
                  border: Border.all(color: AppColors.hex2744.withAlpha(300)),
                  color: AppColors.hex2824.withAlpha(10),
                  boxShape: BoxShape.circle,
                  child: (photo != null && photo.isNotEmpty)
                      ? CustomWidgets.customImageView(
                    path: photo,
                    sourceType: ImageType.network,
                  )
                      : const Icon(Icons.person, size: 100),
                ),
                Positioned(
                    bottom: 10.r,
                    right: 30.r,
                    child: CustomWidgets.customContainer(
                  h: 30.r,
                  w: 30.r,
                  color: AppColors.hex2824,
                  boxShape: BoxShape.circle,
                  alignment: Alignment.center,
                  child: Icon(Icons.edit,color: AppColors.hexEeeb,size: 15.r,)
                  
                ))
              ],
            ),
          ).padTop(20.r).padBottom(100.r),
          widgetCard()


        ],
      ),
    );
  }
  widgetCard(){
    return CustomWidgets.customContainer(
      h: 60.r,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: AppColors.hex2824.withAlpha(30)),


    ).padH(10.r);

  }
}
