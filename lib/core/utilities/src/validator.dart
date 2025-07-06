import 'package:rt_chat/core/utilities/src/strings.dart';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return AppStrings.emailCannotBeEmpty;
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return AppStrings.enterAValidEmail;
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return AppStrings.passwordCannotBeEmpty;
  }
  if (value.length < 6) {
    return AppStrings.passwordMustBeAtLest6Characters;
  }
  return null;
}

String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return AppStrings.nameCannotBeEmpty;
  }
  if (value.length < 2) {
    return AppStrings.nameCannotBeAtLeast2Characters;
  }
  return null;
}

String? validateGender(String? value) {
  if (value == null || value.trim().isEmpty) {
    return AppStrings.genderCannotBeEmpty;
  }
  final lower = value.toLowerCase();
  // todo add enum for male or female
  if (lower != AppStrings.male &&
      lower != AppStrings.female &&
      lower != AppStrings.others) {
    return AppStrings.pleaseEnterMaleOrFemale;
  }
  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  }

  // Remove any non-digit characters
  final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

  // Check length (India: 10 digits)
  if (digitsOnly.length != 10) {
    return 'Enter a valid 10-digit phone number';
  }

  // Optional: pattern match
  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(digitsOnly)) {
    return 'Phone number must start with 6-9 and be 10 digits';
  }

  return null; // Valid
}

String? confirmPasswordValidator(String? confirmPassword, String? password) {
  if (confirmPassword == null || confirmPassword.isEmpty) {
    return AppStrings.pleaseConfirmUPassword;
  }
  if (password != confirmPassword) {
    return AppStrings.passwordDoNotMatch;
  }
  return null;
}
