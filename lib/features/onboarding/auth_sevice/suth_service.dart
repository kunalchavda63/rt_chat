import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:go_router/go_router.dart';
import 'package:rt_chat/core/models/src/user_model/user_model.dart';
import 'package:rt_chat/core/utilities/src/extensions/logger/logger.dart';
import '../../../core/app_ui/app_ui.dart'; // Your toast file


class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
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
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
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

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    showSuccessToast("Signed out");
  }

  Future<void> sendForgotPasswordEmail({required String email}) async {
    try {
      // Step 1: Check if user exists in Firestore
      final userQuery = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        // If no user found, show error and return early
        showErrorToast("User not registered.");
        print("User not registered: $email");
        return;
      }

      // Step 2: Send password reset email using FirebaseAuth
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Step 3: Optional success message
      print("Password reset email sent to $email");
      showSuccessToast("Password reset email sent!");

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorToast("User not registered.");
        print("FirebaseAuth: User not found for $email");
      } else if (e.code == 'invalid-email') {
        showErrorToast("Invalid email address.");
        print("FirebaseAuth: Invalid email $email");
      } else {
        showErrorToast("Firebase error: ${e.message}");
        print("FirebaseAuth error: ${e.message}");
      }
      rethrow;
    } catch (e) {
      showErrorToast("Something went wrong: $e");
      print("General error: $e");
      rethrow;
    }
  }




  Future<void> updateUserName({
    required String username,
    required BuildContext context,
  }) async {
    try {
      await currentUser!.updateDisplayName(username);
      showSuccessToast("Username updated");
    } catch (e) {
      showErrorToast("Username update failed: ${_extractMessage(e)}");
    }
  }


  Future<void> sendEmailVerificationLink(BuildContext context) async {
    try {
      await firebaseAuth.currentUser?.sendEmailVerification();
      showSuccessToast("Verification email sent");
    } catch (e) {
      showErrorToast("Verification email failed: ${_extractMessage(e)}");
      logger.e(e);
    }
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.delete();
      await firebaseAuth.signOut();
      showSuccessToast("Account deleted");
    } catch (e) {
      showErrorToast("Delete failed: ${_extractMessage(e)}");
    }
  }


  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
    required BuildContext context,
  }) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.updatePassword(newPassword);
      showSuccessToast("Password updated");
    } catch (e) {
      showErrorToast("Password update failed: ${_extractMessage(e)}");
    }
  }

  Future<void> reloadUser() async{
    await firebaseAuth.currentUser?.reload();
  }


  // Get Recent Message

  // Helper to extract readable error messages
  String _extractMessage(Object e) {
    if (e is FirebaseAuthException) return e.message ?? "Unknown error";
    return e.toString();
  }
}


class ChatUser {
  final UserModel user;
  final String lastMessage;
  final DateTime timestamp;

  ChatUser({
    required this.user,
    required this.lastMessage,
    required this.timestamp,
  });
}


