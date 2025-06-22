import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/core/models/src/user_model/user_model.dart';
import '../../../../core/services/navigation/src/routes.dart';
import '../../../../core/utilities/utils.dart';
import '../../../onboarding/auth_sevice/suth_service.dart';

class EditName extends ConsumerStatefulWidget {
  final String? user;
  const EditName( {
    this.user,
    super.key});

  @override
  ConsumerState<EditName> createState() => _EditNameState();
}

class _EditNameState extends ConsumerState<EditName> {

  late Size size;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late TextEditingController nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
  }
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user ?? '');
  }


  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(authServiceProvider);
    final user = provider.currentUser;
    final displayName = user?.displayName;

    void updateName() async{
      try{
        await provider.updateUserName(
            username: nameController.text.trim(),
            context: context
        );
      }
      on FirebaseAuthException catch(e){
        debugPrint(e.message);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.hexEeeb,
      appBar: CustomWidgets.customAppBar(
        leading: CustomWidgets.customCircleBackButton(color: AppColors.hexEeeb).padLeft(25.r),
        bgColor: AppColors.hex2824,
        isCenterTitle: false,
        title: CustomWidgets.customText(data: AppStrings.name,style: BaseStyle.s17w400.c(AppColors.hexEeeb))
      ),
      body: Form(
        key: _form,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.5,
              child: CustomWidgets.customImageView(
                  path: AssetImages.imgBg,
                  height: size.height,
                  width: size.width,
                  sourceType: ImageType.asset,
                  fit: BoxFit.cover
              ),
            ),

            CustomWidgets.customContainer(
                h: size.height,
                w: size.width,
              color: AppColors.hexEeeb.withAlpha(200)
            ),
            Column(
              children: [
                20.verticalSpace,

                CustomWidgets.customTextField(
                  validator: validateName,
                  initialValue: displayName,
                  maxLength: 25,
                  textCapitalization: TextCapitalization.words,
                  controller: nameController,
                  focusNode: _nameFocus,
                  label: AppStrings.yourName,
                  labelStyle: BaseStyle.s20w400.c(AppColors.hex2824).line(1),
                  style: BaseStyle.s20w400.c(AppColors.hex2824).line(1),
                  border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.hex2824,width: 2),
                  borderRadius: BorderRadius.circular(20.r))
                ).padH(20.r),
                CustomWidgets.customText(
                    data: AppStrings.peopleWillSee,
                style: BaseStyle.s14w500.c(AppColors.hex2824)).padH(15.r),
                Spacer(),
                CustomWidgets.customButton(
                  onTap: (){
                    updateName();
                  },
                  isFullyWhite: true,
                  label: AppStrings.submit,)
                    .padBottom(MediaQuery.of(context).viewPadding.bottom+36.r)
                .padH(10.r)
              ],
            ),
          ],
        ),
      ),

    );
  }
}
