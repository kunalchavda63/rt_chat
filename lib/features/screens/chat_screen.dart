import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rt_chat/features/screens/provider/provider.dart';
import '../../core/services/navigation/router.dart';
import '../../core/utilities/utils.dart';
import '../onboarding/auth_sevice/suth_service.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({ super.key});

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
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final recentChats = ref.watch(recentUsersProvider);





    final List<String> menuItems = [
      AppStrings.newGroup,
      AppStrings.newBroadCast,
      AppStrings.linkedDevice,
      AppStrings.starred,
      AppStrings.settings
    ];

    final provider = ref.watch(authServiceProvider);
    final user = provider.currentUser;


    return Scaffold(
      appBar: CustomWidgets.customAppBar(
          bgColor: AppColors.hex2824,
        leading: CustomWidgets.customContainer(
          onTap: () {
            // getChatRoomsAndMessages();
            // context.push(RoutesEnum.profileSetup.path,extra: user);
          },
          color: AppColors.hexEeeb,
          alignment: Alignment.center,
          boxShape: BoxShape.circle,
          child: CustomWidgets.customText(
            data: user?.email != null
                ? user!.email!.trim().substring(0, 1).toUpperCase()
                : 'C',
            style: BaseStyle.s17w400.c(AppColors.hex2824),
          ),
        ).padLeft(20),
        title: Row(
          children: [
            CustomWidgets.customText(
              data: user?.displayName ?? AppStrings.noName,
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
      body:  ListView.builder(
            itemCount: recentChats.length,
            itemBuilder: (_, index) {
              final chat = recentChats[index];
              return ListTile(
                title: Text(chat.email),
                // trailing: Text(DateFormat('hh:mm a').format(chat.)),
              );
            },
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


