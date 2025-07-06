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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomWidgets.customAppBar(height: 0,bgColor: AppColors.white),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomWidgets.customImageView(path: AssetImages.imgSignUpLogo,sourceType: ImageType.network,height: size.height/3,width: size.width).padTop(35.r),
            CustomWidgets.customText(data: AppStrings.signUp,style: BaseStyle.s23w500.c(AppColors.hex3b0a)).padBottom(20),
            CustomWidgets.customText(
                data: AppStrings.email,
                style: BaseStyle.s17w400.c(AppColors.hex3b0a)
            ).padLeft(5.r).padBottom(3.r),

            CustomWidgets.customTextField(
              controller: _emailController,
              focusNode: _emailFocus,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.emailAddress,
              style: BaseStyle.s17w400.c(AppColors.hex3b0a),
              padding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.hexF2c9,width: 2)),
            ).padBottom(20.r),
            CustomWidgets.customText(
                data: AppStrings.password,
                style: BaseStyle.s17w400.c(AppColors.hex3b0a)
            ).padLeft(5.r).padBottom(3.r),

            CustomWidgets.customTextField(
              controller: _passwordController,
              focusNode: _passFocus,
              textInputType: TextInputType.visiblePassword,
              obscureText: true,
              style: BaseStyle.s17w400.c(AppColors.hex3b0a),
              padding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.hexF2c9,width: 2)),
            ),

            CustomWidgets.customText(data: AppStrings.forgotPassword,style: BaseStyle.s14w500.c(AppColors.hex8a2b),textAlign: TextAlign.center).padV(10.r),
            CustomWidgets.customButton(
              label: AppStrings.login,
            ),
            Spacer(),
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
    );
  }
}
