import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/core/services/navigation/router.dart';
import 'package:rt_chat/core/utilities/src/helper_method.dart';
import 'package:rt_chat/core/utilities/src/strings.dart';
import 'package:rt_chat/features/onboarding/auth_sevice/suth_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final User? user;

  const SettingsScreen({
    super.key,
    this.user
  });

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(authServiceProvider);
    void logOut() async{
      try{
        await provider.signOut(context);
        if(!context.mounted){return;}
        go(context,RoutesEnum.appEntryPoint.path);

      } on FirebaseAuthException catch (e) {
        debugPrint(e.message);
      }
    }



    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          CustomWidgets.customContainer(
            onTap: (){
              logOut();
            },
            h: 60.r,
              w: MediaQuery.of(context).size.width,
              color: AppColors.hex2824.withAlpha(10),
              padding: EdgeInsets.symmetric(horizontal: 20.r),
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomWidgets.customCircleIcon(h: 20.r,w: 20.r,iconData:Icons.logout_outlined,iconColor: Colors.red).padRight(20.r),
                  CustomWidgets.customText(data: AppStrings.logout,style: BaseStyle.s17w400.c(AppColors.hex7777))
                ],

              ),
          borderRadius: BorderRadius.circular(20.r)
          ).padH(20.r)

        ],
      ),
    );
  }
}

