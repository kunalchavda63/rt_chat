import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/utilities/src/helper_method.dart';
import 'package:rt_chat/core/utilities/src/strings.dart';
import 'package:rt_chat/core/utilities/src/validator.dart';
import 'package:rt_chat/features/screens/provider/provider.dart';

class SearchUsers extends ConsumerStatefulWidget {
  final User? user;
  const SearchUsers({this.user, super.key});

  @override
  ConsumerState<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends ConsumerState<SearchUsers> {
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        ref.read(searchUserProvider.notifier).searchUsers(query);
      }
    });
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
        bgColor: AppColors.hex2824,
        leading: CustomWidgets.customContainer(
          onTap: () => back(context),
          h: 35.r,
          w: 35.r,
          child: Icon(Icons.arrow_back, color: AppColors.hexEeeb),
        ),
        title: Row(
          children: [
            CustomWidgets.customText(
              data: AppStrings.searchUser,
              textAlign: TextAlign.left,
              style: BaseStyle.s20w400.c(AppColors.hexEeeb),
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
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.emailAddress,
            focusNode: _searchFocus,
            fillColor: AppColors.hexEeeb,
            filled: true,
            label: AppStrings.email,
            style: style,
            labelStyle: style,
            border: OutlinedInputBorder(
              borderSide: BorderSide(color: AppColors.hexEeeb),
              borderRadius: BorderRadius.circular(15),
            ),
          ).padH(10).padBottom(10.r).padTop(21.r),

          CustomWidgets.customText(
            data: 'Discover Users',
            style: BaseStyle.s20w400.c(AppColors.hex2824),
          ).padLeft(10),
          searchState.when(
            data:
                (userList) => Expanded(
                  child: ListView.builder(
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

                      return CustomWidgets.customContainer(
                        h: 60.r,
                        color: AppColors.hex2824.withAlpha(100),
                        borderRadius: BorderRadius.circular(15.r),
                        child: Row(
                          children: [
                            user.photoUrl != null
                                ? CustomWidgets.customImageView(
                                  path: user.photoUrl ?? '',
                                  sourceType: ImageType.network,
                                )
                                : CustomWidgets.customContainer(
                                  h: 50.r,
                                  w: 50.r,
                                  color: AppColors.hexEeeb,
                                  border: Border.all(
                                    color: AppColors.hex2824,
                                    width: 2,
                                  ),
                                  boxShape: BoxShape.circle,
                                  child: Icon(Icons.person),
                                ).padLeft(5),
                            SizedBox(width: 10.r),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomWidgets.customText(
                                  data: user.displayName ?? 'No Name',
                                  style: BaseStyle.s17w400
                                      .c(AppColors.hex2824)
                                      .w(700),
                                ),
                                CustomWidgets.customText(
                                  data: user.email,
                                  style: BaseStyle.s14w500.c(AppColors.hex2824),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ).padH(10.r).padV(10);
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
