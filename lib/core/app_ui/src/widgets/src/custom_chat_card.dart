import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/core/models/src/user_model/user_model.dart';
import '../../../../../features/screens/chat/provider/provider.dart';
import '../../../app_ui.dart';

class CustomChatCard extends ConsumerWidget {
  final UserModel? userModel;

  const CustomChatCard({super.key, this.userModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final receiverId = userModel?.uid ?? '';

    // Watch the chat card provider
    final chatStateAsync = ref.watch(chatCardProvider(receiverId));

    return chatStateAsync.when(
      loading: () => _buildLoadingCard(theme, context),
      error: (error, stack) => _buildErrorCard(theme, context, error),
      data: (chat) {
        return CustomWidgets.customContainer(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.primaryColor),
          path: AssetImages.imgBg,
          w: MediaQuery.of(context).size.width,
          color: theme.scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
          child: Row(
            children: [
              CustomWidgets.customContainer(
                h: 40.r,
                w: 40.r,
                color: theme.primaryColor,
                border: Border.all(color: theme.primaryColor),
                boxShape: BoxShape.circle,
                child: Icon(Icons.person, color: theme.scaffoldBackgroundColor),
              ).padRight(10.r),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomWidgets.customText(
                    data: userModel?.displayName ?? 'Name',
                    style: BaseStyle.s15w700
                        .w(500)
                        .c(theme.primaryColor)
                        .family(FontFamily.poppins),
                  ),
                  CustomWidgets.customText(
                    data: chat.lastMessage.isEmpty
                        ? chat.lastMessage
                        : 'No messages yet',
                    style: BaseStyle.s10w700
                        .w(500)
                        .c(theme.primaryColor)
                        .family(FontFamily.poppins),
                  ),
                ],
              ).padV(2.r).padH(5.r),

              Spacer(),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomWidgets.customText(
                    data: '5 Dec', // You can make this dynamic later
                    style: BaseStyle.s14w500
                        .line(1.0)
                        .c(theme.primaryColor)
                        .family(FontFamily.poppins),
                  ).padBottom(5.r),

                  // Show unread count badge if there are unread messages
                  if (chat.unreadCount > 0)
                    CustomWidgets.customContainer(
                      h: 20.r,
                      w: 20.r,
                      color: theme.primaryColor,
                      alignment: Alignment.center,
                      boxShape: BoxShape.circle,
                      child: CustomWidgets.customText(
                        textAlign: TextAlign.center,
                        data: '${chat.unreadCount}',
                        style: BaseStyle.s10w700.c(theme.scaffoldBackgroundColor),
                      ),
                    ),
                ],
              ).padV(2.r).padH(5.r),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingCard(ThemeData theme, BuildContext context) {
    return CustomWidgets.customContainer(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: theme.primaryColor),
      w: MediaQuery.of(context).size.width,
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
      child: Row(
        children: [
          CustomWidgets.customContainer(
            h: 40.r,
            w: 40.r,
            color: Colors.grey[300],
            border: Border.all(color: theme.primaryColor),
            boxShape: BoxShape.circle,
          ).padRight(10.r),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16.r,
                  width: 100.r,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 4.r),
                Container(
                  height: 12.r,
                  width: 150.r,
                  color: Colors.grey[300],
                ),
              ],
            ).padV(2.r).padH(5.r),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(ThemeData theme, BuildContext context, dynamic error) {
    return CustomWidgets.customContainer(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.red),
      w: MediaQuery.of(context).size.width,
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
      child: Row(
        children: [
          CustomWidgets.customContainer(
            h: 40.r,
            w: 40.r,
            color: Colors.red[100],
            border: Border.all(color: Colors.red),
            boxShape: BoxShape.circle,
            child: Icon(Icons.error, color: Colors.red),
          ).padRight(10.r),
          Expanded(
            child: CustomWidgets.customText(
              data: 'Error loading chat',
              style: BaseStyle.s14w500.c(Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}