import 'package:flutter/material.dart';
import 'package:rt_chat/core/services/navigation/router.dart';
import 'package:rt_chat/core/services/repositories/service_locator.dart';


Future<void> main() async {
await setupServiceLocator();
  runApp(MyApp());

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(),
      navigatorKey: getIt<AppRouter>().navigatorKey,
    );
  }
}
