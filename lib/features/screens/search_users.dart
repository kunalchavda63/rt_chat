import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/core/services/navigation/router.dart';
import 'package:rt_chat/core/utilities/utils.dart';
import 'package:rt_chat/features/screens/provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchUsers extends ConsumerStatefulWidget {
  const SearchUsers({super.key});

  @override
  ConsumerState<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends ConsumerState<SearchUsers> {
  late Size size;
  late ThemeData theme;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  final style = BaseStyle.s17w400
      .c(AppColors.hex2824)
      .family(FontFamily.poppins)
      .line(0.9);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(searchUserProvider.notifier).fetchAllUsers();
    });

    _searchController.addListener(() {
      final query = _searchController.text.trim();
      if (query.isEmpty) {
        ref.read(searchUserProvider.notifier).fetchAllUsers();
      } else {
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
            const Spacer(),
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
            border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primaryColor),
              borderRadius: BorderRadius.circular(15),
            ),
          ).padH(10).padBottom(10.r).padTop(21.r),

          CustomWidgets.customText(
            data: AppStrings.discoverUsers,
            style: BaseStyle.s20w400.c(theme.primaryColor),
          ).padLeft(10),

          searchState.when(
            data: (userList) {
              return (userList.isEmpty) ? Center(
              child: CustomWidgets.customText(
                data: 'User Not Found',
                style: BaseStyle.s28w400
                  .w(400)
              ).padTop(size.height/4),
            ): Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final user = userList[index];

                  if (index == userList.length - 1) {
                    ref.read(searchUserProvider.notifier).searchUsers(
                      _searchController.text.trim(),
                      isNewSearch: false,
                    );
                  }

                  return CustomWidgets.customAnimationWrapper(
                    duration: Duration(milliseconds: 800),
                    curve: Curves.decelerate,
                    animationType: AnimationType.fade,
                    child: CustomWidgets.customChatCard(
                        onTap: (){
                          ref.read(recentUsersProvider.notifier).addOrMoveToTop(user);
                          context.push(RoutesEnum.chatRoomScreen.path, extra: user);
                        },
                        user: user)
                        .padH(20.r)
                        .padV(10.r),
                  );
                },
              ),
            );
            },
            loading: () => Expanded(
              child: Skeletonizer(
                enabled: false,
                child: ListView.builder(
                  itemCount: 6,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Skeleton text lines
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 12,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 12,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),


            error: (e, _) => Text('Error: $e'),
          ),
        ],
      ),
    );
  }
}
