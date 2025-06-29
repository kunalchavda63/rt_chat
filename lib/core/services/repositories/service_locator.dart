import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:rt_chat/core/services/repositories/auth_repository.dart';

import '../../../firebase_options.dart';
import '../../app_ui/app_ui.dart';
import '../navigation/src/app_router.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  getIt.registerLazySingleton(() =>  AppRouter());
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => AuthRepository());
}