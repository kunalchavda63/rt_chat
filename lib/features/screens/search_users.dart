import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_chat/bloc/recent_user_bloc/recent_user_cubit.dart';
import 'package:rt_chat/bloc/search_user_bloc/search_cubit.dart';
import 'package:rt_chat/core/services/navigation/src/app_router.dart';
import 'package:rt_chat/core/services/repositories/service_locator.dart';
import 'package:rt_chat/core/utilities/utils.dart';
import 'package:rt_chat/features/screens/chat_room/chat_room_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/app_ui/app_ui.dart';

class SearchUsers extends StatefulWidget {
  const SearchUsers({super.key});

  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  late Size size;
  late ThemeData theme;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  Timer? debouncer;
  final style = BaseStyle.s17w400
      .c(AppColors.hex2824)
      .family(FontFamily.poppins)
      .line(0.9);
  @override
  void initState() {
    super.initState();
    context.read<SearchUserCubit>().fetchAllUser();
    _searchController.addListener(() {
      final query = _searchController.text.trim();
      if(debouncer?.isActive ?? false) debouncer?.cancel();
      debouncer = Timer(const Duration(milliseconds: 300), (){
        if (query.isEmpty) {
          context.read<SearchUserCubit>().fetchAllUser(isNewSearch: true);
        } else {
          context.read<SearchUserCubit>().searchUser(query, isNewSearch: true);
        }
      });
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

          Expanded(
            child: BlocBuilder<SearchUserCubit, SearchUserState>(
              builder: (context, state) {
                if (state is SearchUserLoading) {
                  return Skeletonizer(
                    enabled: true,
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
                  );
                } else if (state is SearchUserLoaded) {
                  final userList = state.users;
                  if (userList.isEmpty) {
                    return Center(
                      child: CustomWidgets.customText(
                        data: 'User Not Found',
                        style: BaseStyle.s28w400.w(400),
                      ).padTop(size.height / 4),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final user = userList[index];
                      if(index == userList.length-1 && _searchController.text.trim().isNotEmpty){
                        context.read<SearchUserCubit>().searchUser(
                          _searchController.text.trim(),
                          isNewSearch: false
                        );
                      }


                      return CustomWidgets.customAnimationWrapper(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.decelerate,
                        animationType: AnimationType.fade,
                        child: CustomWidgets.customChatCard(
                          onTap: () {
                            context.read<RecentUserCubit>().addOrMoveToTop(user);
                            getIt<AppRouter>().push(ChatRoomScreen(receiverEmail: user.email, receiverId: user.uid!, displayName: user.displayName!));

                          },
                          user: user,
                        ).padH(20.r).padV(10.r),
                      );
                    },
                  );
                } else if (state is SearchUserError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
