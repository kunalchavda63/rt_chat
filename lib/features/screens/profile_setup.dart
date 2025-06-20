import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/utilities/src/helper_method.dart';
import '../onboarding/auth_sevice/suth_service.dart';

class ImageProfileUpdate extends ConsumerStatefulWidget {
  const ImageProfileUpdate({super.key});

  @override
  ConsumerState<ImageProfileUpdate> createState() => _ImageProfileUpdateState();
}

class _ImageProfileUpdateState extends ConsumerState<ImageProfileUpdate> {
  ImagePicker picker = ImagePicker();
  late Size size;
   XFile? file;

  Future<void> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          file = pickedFile;
        });
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
     final provider=  ref.watch(authServiceProvider);
     User? user = provider.currentUser;
     String? photo = user?.photoURL;
     String displayName = (user?.displayName?.trim().isNotEmpty ?? false)
         ? user!.displayName!
         : 'No Name ';
     String phone = (user?.phoneNumber?.trim().isNotEmpty??false)
         ? user!.phoneNumber!
         : 'No Phone Number ';

     return Scaffold(
      backgroundColor: AppColors.hexEeeb,
      appBar: CustomWidgets.customAppBar(
        isCenterTitle: false,
        autoImplyLeading: false,
        leading: CustomWidgets.customCircleBackButton(color: AppColors.hexEeeb).padLeft(25.r),
        bgColor: AppColors.hex2824,
          title: CustomWidgets.customText(data: 'Account Setup',style: BaseStyle.s17w400.c(AppColors.hexEeeb),),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.1,
            child: CustomWidgets.customImageView(
              path: AssetImages.imgBg,
              fit: BoxFit.cover,
                //TODO: implement didChangeDependencies
              height: size.height,
              width: size.width,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // todo add Firebase photo update method
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
                        child: CustomWidgets.customCircleIcon(
                          onTap: (){
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                              backgroundColor: AppColors.hexEeeb, // ✅ This sets the background color of the modal sheet
                              builder: (context) {
                                return SizedBox(
                                  height: MediaQuery.of(context).size.height/3,
                                  child: Column(
                                    children: [
                                      
                                      CustomWidgets.customText(data: 'Choose an option to Upload Picture',style: BaseStyle.s17w400.c(AppColors.hex2824)).padV(15.r),
                                      widgetCard(
                                          context: context,
                                          icon:Icons.camera_alt_outlined,
                                          title: 'Camera',
                                          isBottomSheet: true,
                                          onTap: () {
                                            back(context);
                                            pickImage(source: ImageSource.camera);
                                            },
                                      ),
                                      widgetCard(
                                          context: context,
                                          onTap: (){
                                            back(context);
                                            pickImage(source: ImageSource.gallery);
                                          },
                                          icon:Icons.photo_sharp,
                                          title: 'Gallery',
                                          isBottomSheet: true
                                      ),

                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          h: 30.r,
                          w: 30.r,
                          iconColor: AppColors.hexEeeb,
                          iconSize: 15.r,
                          iconData: Icons.edit,
                          bgColor: AppColors.hex2824,

                        )

                    )
                  ],
                ),
              ).padTop(20.r).padBottom(100.r),
              widgetCard(subtitle: displayName,icon: Icons.person_2_outlined,context: context),
              widgetCard(title:'About',subtitle: displayName,icon: Icons.info_outline,description: 'Jay Shree Ram',context: context),
              widgetCard(title:'Phone',subtitle: phone,icon: Icons.call_outlined,context: context),
              widgetCard(title:'Link',subtitle: displayName,icon: Icons.link,context: context),


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
    String? description,
    bool isBottomSheet= false
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
            iconData: icon
          ).padH(15.r),

          /// Wrap text in Flexible/Expanded to avoid overflow
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomWidgets.customText(
                  data: title ?? 'Name',
                  style: BaseStyle.s17w400.c(AppColors.hex2824),
                ),
                  if(isBottomSheet==false)CustomWidgets.customText(
                    data: subtitle??'No Data',
                    style: BaseStyle.s14w500.c(AppColors.hex2824),
                  ),
              ],
            ),
          ),

          if(description!=null)
            SizedBox(
            width: 80,
            child: CustomWidgets.customText(
              data: description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: BaseStyle.s11w700.c(AppColors.hex2824)
            ),
          ).padRight(10.r)
          

        ],
      ),
    ).padH(10.r).padV(10.r);
  }

}
