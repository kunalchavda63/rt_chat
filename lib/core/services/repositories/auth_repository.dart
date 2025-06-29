import 'package:firebase_auth/firebase_auth.dart';
import 'package:rt_chat/core/services/repositories/base_repository.dart';
import 'package:rt_chat/core/services/repositories/service_locator.dart';

import '../../app_ui/app_ui.dart';
import '../../models/src/user_model/user_model.dart';

class AuthRepository extends BaseRepository{
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      showSuccessToast("Signed in successfully");
      return userCredential;
    } catch (e) {
      showErrorToast("Sign-in failed: ${_extractMessage(e)}");
      rethrow;
    }
  }

  Future<UserCredential?> createAccount({
    required UserModel user,
  }) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,

      );

      final uid = userCredential.user!.uid;



      final userModel = UserModel(
        uid: uid,
        email: user.email,
        displayName: user.displayName ?? '', // Optional
        phone: user.phone ?? '',
        photoUrl: user.photoUrl ?? '',
        role: user.role??'guest', password: user.password, // You can update this based on your logic
      );

      await firestore.collection("users").doc(uid).set(userModel.toJson());

      showSuccessToast("Account created successfully!");
      return userCredential;
    } catch (e) {
      showErrorToast("Account creation failed: ${_extractMessage(e)}");
      return null;
    }
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      firestore.collection("users").doc(user.uid).set(user.toMap());
    } catch (e) {
      throw 'Failed to save user Data';
    }
  }

  Future<UserModel> getUserData(String uid) async {
    try {
      final doc = await firestore.collection("users").doc(uid).get();
      if (!doc.exists) {
        throw "User data not found";
      }
      return UserModel.fromFirestore(doc as Map<String,dynamic>,doc.id);
    } catch (e) {
      throw 'Failed to save user Data';
    }
  }
  Future<void> signOut() async {
    await getIt<AuthRepository>().auth.signOut();
    showSuccessToast("Signed out");
  }
  Future<void> sendForgotPasswordEmail({required String email}) async {
    try {
      // Step 1: Check if user exists in Firestore
      final userQuery = await getIt<AuthRepository>().firestore
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        // If no user found, show error and return early
        showErrorToast("User not registered.");
        debugPrint("User not registered: $email");
        return;
      }

      // Step 2: Send password reset email using FirebaseAuth
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Step 3: Optional success message
      debugPrint("Password reset email sent to $email");
      showSuccessToast("Password reset email sent!");

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorToast("User not registered.");
        debugPrint("FirebaseAuth: User not found for $email");
      } else if (e.code == 'invalid-email') {
        showErrorToast("Invalid email address.");
        debugPrint("FirebaseAuth: Invalid email $email");
      } else {
        showErrorToast("Firebase error: ${e.message}");
        debugPrint("FirebaseAuth error: ${e.message}");
      }
      rethrow;
    } catch (e) {
      showErrorToast("Something went wrong: $e");
      debugPrint("General error: $e");
      rethrow;
    }
  }


  String _extractMessage(Object e) {
    if (e is FirebaseAuthException) return e.message ?? "Unknown error";
    return e.toString();
  }

}