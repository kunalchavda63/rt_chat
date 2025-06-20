import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/services/navigation/router.dart';
import 'package:rt_chat/core/utilities/src/extensions/logger/logger.dart';
import 'package:rt_chat/core/utilities/src/helper_method.dart';
import 'package:rt_chat/core/utilities/src/strings.dart';
import 'package:rt_chat/features/onboarding/auth_sevice/suth_service.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final User? user;
  const ChatScreen({this.user, super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late Size size;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setStatusBarDarkStyle();
    size = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> menuItems = [
      AppStrings.newGroup,
      AppStrings.newBroadCast,
      AppStrings.linkedDevice,
      AppStrings.starred,
      AppStrings.settings
    ];

    final provider = ref.watch(authServiceProvider);

    return Scaffold(
      appBar: CustomWidgets.customAppBar(
          bgColor: AppColors.hex2824,
        leading: CustomWidgets.customContainer(
          onTap: () {
            push(context, RoutesEnum.profileSetup.path);
          },
          color: AppColors.hexEeeb,
          alignment: Alignment.center,
          boxShape: BoxShape.circle,
          child: CustomWidgets.customText(
            data: widget.user?.email != null
                ? widget.user!.email!.trim().substring(0, 1).toUpperCase()
                : 'C',
            style: BaseStyle.s17w400.c(AppColors.hex2824),
          ),
        ).padLeft(20),
        title: Row(
          children: [
            CustomWidgets.customText(
              data: widget.user?.displayName ?? 'No Name',
              style: BaseStyle.s17w400.c(AppColors.hexEeeb),
            ),
            Spacer(),
            CustomWidgets.customPopUpMenuBtm(
              items: menuItems,
              icon: Icon(Icons.more_vert,color: AppColors.hexEeeb,),
              onSelected: (value){
                context.push(RoutesEnum.settings.path);
                // context.pushNamed()
              }

            )
          ],
        ),
      ),
      floatingActionButton: CustomWidgets.customFloatingActionButton(
        child: Icon(Icons.search, color: AppColors.hexEeeb),
        onTap: () {
          context.push(RoutesEnum.searchUser.path);
        },
        backgroundColor: AppColors.hex2824,
      ),
    );
  }
}
