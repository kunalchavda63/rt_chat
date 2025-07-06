import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rt_chat/core/services/navigation/router.dart';
import 'package:rt_chat/core/services/repositories/service_locator.dart';

import 'features/onboarding/login_screen.dart';


Future<void> main() async {

await setupServiceLocator();
  runApp(MyApp());

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375,812),
      builder: (context,_){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LoginScreen(),
          navigatorKey: getIt<AppRouter>().navigatorKey,
        );
      }
    );
  }
}
