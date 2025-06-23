import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/core/services/navigation/router.dart';
import 'package:rt_chat/core/utilities/utils.dart';
import 'package:rt_chat/features/screens/provider/provider.dart';

class SearchUsers extends ConsumerStatefulWidget {
  const SearchUsers({super.key});

  @override
  ConsumerState<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends ConsumerState<SearchUsers> {
  late Size size;
  late ThemeData theme;
  @override
  void initState() {
    super.initState();

    // Initial fetch
    Future.microtask(() {
      ref.read(searchUserProvider.notifier).fetchAllUsers();
    });

    // Search input listener
    _searchController.addListener(() {
      final query = _searchController.text.trim();

      if (query.isEmpty) {
        // 👇 Fetch all users if input is empty
        ref.read(searchUserProvider.notifier).fetchAllUsers();
      } else {
        // 👇 Search users
        ref.read(searchUserProvider.notifier).searchUsers(query);
      }
    });
  }
@override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);
    size = MediaQuery.of(context).size;

  }

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final style = BaseStyle.s17w400
      .c(AppColors.hex2824)
      .family(FontFamily.poppins)
      .line(0.9);

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchUserProvider);

    return Scaffold(
      appBar: CustomWidgets.customAppBar(
        bgColor: theme.scaffoldBackgroundColor,
        leading: CustomWidgets.customContainer(
          onTap: () => back(context),
          h: 35.r,
          w: 35.r,
          child: Icon(Icons.arrow_back, color: theme.primaryColor),
        ),
        title: Row(
          children: [
            CustomWidgets.customText(
              data: AppStrings.searchUser,
              textAlign: TextAlign.left,
              style: BaseStyle.s20w400.c(theme.primaryColor),
            ),
            Spacer(),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomWidgets.customTextField(
            validator: validateName,
            controller: _searchController,
            textInputType: TextInputType.emailAddress,
            focusNode: _searchFocus,
            fillColor: theme.scaffoldBackgroundColor,
            filled: true,
            label: AppStrings.email,
            style: style.c(theme.primaryColor),
            labelStyle: style.c(theme.primaryColor),
            border: OutlinedInputBorder(
              borderSide: BorderSide(color:theme.primaryColor),
              borderRadius: BorderRadius.circular(15),
            ),
          ).padH(10).padBottom(10.r).padTop(21.r),

          CustomWidgets.customText(
            data: AppStrings.discoverUsers,
            style: BaseStyle.s20w400.c(theme.primaryColor),
          ).padLeft(10),
          searchState.when(
            data:
                (userList) => Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final user = userList[index];
                      // ✅ Pagination trigger
                      if (index == userList.length - 1) {
                        ref
                            .read(searchUserProvider.notifier)
                            .searchUsers(
                              _searchController.text.trim(),
                              isNewSearch: false,
                            );
                      }

                      return InkWell(
                        onTap: (){
                          context.push(RoutesEnum.chatRoomScreen.path,extra: user);
                        },
                        child: CustomWidgets.customChatCard(

                            user: user).padH(20.r).padV(10.r),
                      );
                    },
                  ),
                ),
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),
        ],
      ),
    );
  }
}
