import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/features/screens/chat/provider/provider.dart';
import 'package:rt_chat/features/screens/provider/provider.dart';

import '../../core/services/navigation/router.dart';
import '../../core/utilities/utils.dart';
import '../onboarding/provider/provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late Size size;
  late ThemeData theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    setStatusBarDarkStyle();
  }

  @override
  Widget build(BuildContext context) {
    final recentChatsAsync = ref.watch(recentUsersProvider);
    final provider = ref.watch(authServiceProvider);
    final user = provider.currentUser;

    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      appBar: CustomWidgets.customAppBar(
        bgColor: theme.scaffoldBackgroundColor,
        leading: CustomWidgets.customContainer(
          onTap: () {
            context.push(RoutesEnum.profileSetup.path, extra: user);
          },
          color: theme.primaryColor.withAlpha(40),
          alignment: Alignment.center,
          boxShape: BoxShape.circle,
          child: CustomWidgets.customText(
            data: user?.email?.substring(0, 1).toUpperCase() ?? 'C',
            style: BaseStyle.s17w400.c(theme.primaryColor),
          ),
        ).padLeft(20),
        title: Row(
          children: [
            CustomWidgets.customText(
              data: user?.displayName ?? AppStrings.noName,
              style: BaseStyle.s17w400.c(textColor),
            ),
            const Spacer(),
            CustomWidgets.customPopUpMenuBtm(
              items: const [
                AppStrings.newGroup,
                AppStrings.newBroadCast,
                AppStrings.linkedDevice,
                AppStrings.starred,
                AppStrings.settings,
              ],
              icon: Icon(Icons.more_vert, color: textColor),
              onSelected: (value) {
                context.push(RoutesEnum.settings.path);
              },
            ),
          ],
        ),
      ),
      body:ListView.builder(
            itemCount: recentChatsAsync.length,
            itemBuilder: (_, index) {
              final chatUser = recentChatsAsync[index];
              return CustomWidgets.customChatCard(
                user: chatUser,
                onTap: () {
                  markMessagesAsRead(chatUser.uid!);
                  context.push(RoutesEnum.chatRoomScreen.path, extra: chatUser);
                },
              ).padH(10.r).padV(10.r);
            },
          ),
      floatingActionButton: CustomWidgets.customFloatingActionButton(
        child: Icon(Icons.search, color: theme.colorScheme.onPrimary),
        onTap: () {
          context.push(RoutesEnum.searchUser.path);
        },
        backgroundColor: theme.primaryColor,
      ),
    );
  }
}
