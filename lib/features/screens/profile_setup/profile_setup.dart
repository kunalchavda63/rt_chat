import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/core/models/src/user_model/user_model.dart';
import 'package:rt_chat/core/services/navigation/router.dart';
import 'package:rt_chat/core/utilities/utils.dart';

class ImageProfileUpdate extends ConsumerStatefulWidget {
  const ImageProfileUpdate( {
    super.key,
    });

  @override
  ConsumerState<ImageProfileUpdate> createState() => _ImageProfileUpdateState();
}

class _ImageProfileUpdateState extends ConsumerState<ImageProfileUpdate> {
  late Size size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    final current = FirebaseAuth.instance.currentUser;
    final displayName = current?.displayName;
    final phone = current?.phoneNumber;
    final email = current?.email;



    return Scaffold(
      backgroundColor: AppColors.hexEeeb,
      appBar: CustomWidgets.customAppBar(
        isCenterTitle: false,
        autoImplyLeading: false,
        leading: CustomWidgets.customCircleBackButton(color: AppColors.hexEeeb).padLeft(25.r),
        bgColor: AppColors.hex2824,
        title: CustomWidgets.customText(
          data: AppStrings.account,
          style: BaseStyle.s17w400.c(AppColors.hexEeeb),
        ),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.1,
            child: CustomWidgets.customImageView(
              path: AssetImages.imgBg,
              fit: BoxFit.cover,
              height: size.height,
              width: size.width,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              widgetCard(
                title: AppStrings.name,
                subtitle: displayName,
                icon: Icons.person_2_outlined,
                context: context,
                onTap: (){
                  context.push(RoutesEnum.editName.path,extra: current?.displayName);
                }
              ),
              widgetCard(
                title: AppStrings.about,
                subtitle: displayName,
                icon: Icons.info_outline,
                context: context,
                  onTap: (){
                    push(context,RoutesEnum.editName.path);
                  }
              ),
              widgetCard(
                title: AppStrings.phone,
                subtitle: phone,
                icon: Icons.call_outlined,
                context: context,
              ),
              widgetCard(
                title: AppStrings.link,
                subtitle: email,
                icon: Icons.link,
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  widgetCard({
    IconData? icon,
    BuildContext? context,
    String? title,
    String? subtitle,
    VoidCallback? onTap,
    bool isBottomSheet = false,
  }) {
    return CustomWidgets.customContainer(
      onTap: onTap,
      h: 60.r,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: AppColors.hex2824.withAlpha(30)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomWidgets.customCircleIcon(
            h: 30.r,
            w: 30.r,
            iconColor: AppColors.hex2824.withAlpha(100),
            iconSize: 30,
            iconData: icon,
          ).padH(15.r),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomWidgets.customText(
                  data: title ?? AppStrings.noName,
                  style: BaseStyle.s17w400.c(AppColors.hex2824),
                ),
                if (!isBottomSheet)
                  CustomWidgets.customText(
                    data: subtitle ?? AppStrings.noName,
                    style: BaseStyle.s14w500.c(AppColors.hex2824),
                  ),
              ],
            ),
          ),


        ],
      ),
    ).padH(10.r).padV(10.r);
  }
}
