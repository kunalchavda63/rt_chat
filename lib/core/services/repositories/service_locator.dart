import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:rt_chat/core/services/navigation/router.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerLazySingleton(() => AppRouter()
  );


}
