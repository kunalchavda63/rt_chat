import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/bloc/recent_user_bloc/recent_user_cubit.dart';
import 'package:rt_chat/features/onboarding/auth_sevice/suth_service.dart';
import 'package:rt_chat/features/screens/chat/provider/provider.dart';
import 'package:rt_chat/features/screens/chat_room/chat_room_screen.dart';
import 'package:rt_chat/features/screens/provider/provider.dart';

import '../../core/services/navigation/router.dart';
import '../../core/utilities/utils.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
    final AuthService provider = AuthService();
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
      body:BlocBuilder<RecentUserCubit,RecentUserState>(
        builder: (context,state) {
          if(state is RecentUserInitial){
            return CircularProgressIndicator();
          }
          else if(state is RecentUserLoading){
            return CircularProgressIndicator();
          }
          else if(state is RecentUserLoaded){
            final list = state.users;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, index) {
                final chatUser = list[index];
                return CustomWidgets.customChatCard(
                  user: chatUser,
                  onTap: () {
                    markMessagesAsRead(chatUser.uid!);
                    Navigator.push(context,MaterialPageRoute(builder: (context)=> ChatRoomScreen(
                        receiverEmail: chatUser.email,
                        receiverId: chatUser.uid!,
                        displayName:chatUser.displayName!
                    )));
                  },
                ).padH(10.r).padV(10.r);
              },
            );
          }
          return SizedBox.shrink();


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
