class TValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    // Regular expression for phone number validation (assuming a 10-digit US phone number format)
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required).';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required.';
    }

    // // Regular expression for name validation (no special characters)
    // final nameRegExp = RegExp(r'^[a-zA-Z_0-9]+$');

    // if (!nameRegExp.hasMatch(value)) {
    //   return 'Tên không được chứa kí tự đặc biệt.';
    // }

    return null;
  }

  static String? validateRetypePassword(String? value, String? newPassword) {
    if (value == null || value.isEmpty) {
      return 'Repeat password.';
    } else if (value != newPassword) {
      return 'Password doesn\'t match.';
    }

    return null;
  }

  static String? validateOldPassword(String? value, String? oldPassword) {
    if (value == null || value.isEmpty) {
      return 'Insert password.';
    } else if (value != oldPassword) {
      return 'Password is incorrect.';
    }

    return null;
  }

// Add more custom validators as needed for your specific requirements.
}
