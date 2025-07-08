import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/services/navigation/router.dart';
import 'package:rt_chat/core/services/repositories/service_locator.dart';
import 'package:rt_chat/core/utilities/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late Size size;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _confirmPassFocus = FocusNode();
  final FocusNode _userIdFocus = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomWidgets.customAppBar(height: 0,bgColor: AppColors.white,),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomWidgets.customImageView(path: AssetImages.imgSignUpLogo,sourceType: ImageType.network,height: size.height/3,width: size.width).padTop(20.r),
              CustomWidgets.customText(data: AppStrings.signUp,style: BaseStyle.s23w500.c(AppColors.hex3b0a)).padBottom(20.r),
              CustomWidgets.customText(
                  data: AppStrings.name,
                  style: BaseStyle.s17w400.c(AppColors.hex3b0a)
              ).padLeft(5.r).padBottom(3.r),
              buildField(focusNode: _nameFocus, controller:_nameController,textInputAction: TextInputAction.next,textInputType: TextInputType.name).padBottom(20.r),
              CustomWidgets.customText(
                  data: AppStrings.userid,
                  style: BaseStyle.s17w400.c(AppColors.hex3b0a)
              ).padLeft(5.r).padBottom(3.r),
              buildField(focusNode: _userIdFocus, controller:_userIdController,textInputAction: TextInputAction.next,textInputType: TextInputType.name).padBottom(20.r),
              CustomWidgets.customText(
                  data: AppStrings.email,
                  style: BaseStyle.s17w400.c(AppColors.hex3b0a)
              ).padLeft(5.r).padBottom(3.r),
              buildField(focusNode: _emailFocus, controller:_emailController,textInputAction: TextInputAction.next,textInputType: TextInputType.emailAddress).padBottom(20.r),
              CustomWidgets.customText(
                  data: AppStrings.phone,
                  style: BaseStyle.s17w400.c(AppColors.hex3b0a)
              ).padLeft(5.r).padBottom(3.r),
              buildField(focusNode: _phoneFocus, controller:_phoneController,textInputAction: TextInputAction.next,textInputType: TextInputType.phone).padBottom(20.r),
              CustomWidgets.customText(
                  data: AppStrings.password,
                  style: BaseStyle.s17w400.c(AppColors.hex3b0a)
              ).padLeft(5.r).padBottom(3.r),
              buildField(focusNode: _passFocus, controller:_passwordController,textInputAction: TextInputAction.next,textInputType: TextInputType.visiblePassword,obscureText: true).padBottom(20.r),
              CustomWidgets.customText(
                  data: AppStrings.confirmPassword,
                  style: BaseStyle.s17w400.c(AppColors.hex3b0a)
              ).padLeft(5.r).padBottom(3.r),
              buildField(focusNode: _confirmPassFocus, controller:_confirmPassController,textInputType: TextInputType.visiblePassword,obscureText: true).padBottom(10.r),
              CustomWidgets.customButton(
                label: AppStrings.login,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomWidgets.customText(
                      data: AppStrings.alreadyHaveAnAccount,
                      style: BaseStyle.s16w500.c(AppColors.hex8a2b)
                  ),
                  GestureDetector(
                    onTap: ()=>getIt<AppRouter>().pop(),
                    child: CustomWidgets.customText(
                      data: " ${AppStrings.login}",
                      style: BaseStyle.s14w500.c(AppColors.hex3b0a),
                    ),
                  ),
                ],
              ).padBottom(MediaQuery.of(context).viewInsets.bottom+MediaQuery.of(context).viewPadding.bottom+25.r),
            ],
          ).padH(20.r),
        ),
      ),
    );
  }

  Widget buildField({
     required FocusNode focusNode,
    required TextEditingController controller,
    TextInputAction? textInputAction,
    TextInputType? textInputType,
    bool? obscureText,
}) {
    return
      CustomWidgets.customTextField(
        controller: controller,
        focusNode: focusNode,
        textInputType: textInputType,
        obscureText: obscureText,
        style: BaseStyle.s17w400.c(AppColors.hex3b0a),
        padding: EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.hexF2c9, width: 2)),
      );
  }
}
