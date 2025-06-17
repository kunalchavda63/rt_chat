import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/services/navigation/router.dart';
import 'package:rt_chat/core/utilities/src/extensions/logger/logger.dart';
import 'package:rt_chat/core/utilities/src/helper_method.dart';
import 'package:rt_chat/features/onboarding/auth_sevice/suth_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final User? user;
  const HomeScreen({this.user, super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Size size;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setStatusBarDarkStyle();
    size = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    logger.i(widget.user);
    final provider = ref.watch(authServiceProvider);
    void logOut() async {
      await provider.signOut();
      logger.i('Log Out User');
      if (!context.mounted) return;
      push(context, RoutesEnum.appEntryPoint.path);
    }

    return Scaffold(
      body: Stack(
        children: [
          CustomWidgets.customContainer(
            h: size.height,
            w: size.width,
            color: AppColors.hexF8f4,
          ),
          Positioned(
            child: Opacity(
              opacity: 0.3,
              child: CustomWidgets.customImageView(
                sourceType: ImageType.asset,
                path: AssetImages.imgBg,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.10,
            left: 0,
            right: 0,
            child: CustomWidgets.customContainer(
              borderRadius: BorderRadius.circular(30),
              h: size.height,
              w: size.width,
              color: AppColors.hex5c23,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomWidgets.customText(
                    data: 'Chats',
                    style: BaseStyle.s20w900
                        .c(AppColors.hexF8f4)
                        .family(FontFamily.signPainter),
                  ).padTop(20).padH(20.r),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return CustomWidgets.customChatCard().padSymmetric(
                          horizontal: 10.r,
                          vertical: 9.r,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 35.r,
            left: 21.r,
            child: Row(
              children: [
                CustomWidgets.customContainer(
                  h: 35.r,
                  w: 35.r,
                  alignment: Alignment.center,
                  color: AppColors.hex5c23,
                  boxShape: BoxShape.circle,
                  child: CustomWidgets.customText(
                    data: 'KC',
                    textAlign: TextAlign.center,
                    style: BaseStyle.s20w900
                        .w(900)
                        .c(AppColors.hexF5f5)
                        .family(FontFamily.signPainter),
                  ),
                ).padRight(10.r),
                CustomWidgets.customText(
                  data: 'Kunal Chavda',
                  style: BaseStyle.s14w500
                      .c(AppColors.hex5c23)
                      .w(700)
                      .family(FontFamily.poppins),
                ),
              ],
            ),
          ),
          Positioned(
            right: 21.r,
            top: 35.r,
            child: CustomWidgets.customContainer(
              h: 35.r,
              w: 35.r,
              padding: EdgeInsets.all(5),
              boxShape: BoxShape.circle,
              onTap: logOut,
              color: AppColors.hex5c23,
              child: Icon(Icons.logout, size: 18, color: AppColors.hexF5f5),
            ),
          ),
        ],
      ),
    );
  }
}
