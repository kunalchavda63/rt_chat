import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/services/navigation/router.dart';
import 'package:rt_chat/core/utilities/src/extensions/logger/logger.dart';
import 'package:rt_chat/core/utilities/src/helper_method.dart';
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
    final provider = ref.watch(authServiceProvider);
    void logOut() async {
      await provider.signOut(context);
      logger.i('Log Out User');
      if (!context.mounted) return;
      push(context, RoutesEnum.appEntryPoint.path);
    }

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
          child: Text('K', style: BaseStyle.s17w400.c(AppColors.hex2824)),
        ).padLeft(20),
        title: Row(
          children: [
            CustomWidgets.customText(
              data: widget.user?.displayName ?? 'No Name',
              style: BaseStyle.s17w400.c(AppColors.hexEeeb),
            ),
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
