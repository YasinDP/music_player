class Validator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null; // Return null if email is valid
  }

  static String? validateName(
    String? value, {
    bool isRequired = false,
  }) {
    if (isRequired && (value == null || value.isEmpty)) {
      return 'Name is required';
    }
    if (value != null || value!.isNotEmpty) {
      final nameRegex = RegExp(r'^[a-zA-Z ]+$');
      if (!nameRegex.hasMatch(value)) {
        return 'Please enter a valid name';
      }
    }
    return null; // Return null if name is valid or empty
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null; // Return null if password is valid
  }
}
