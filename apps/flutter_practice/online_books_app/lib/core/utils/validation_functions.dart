// Check if String consists only Alphabets
bool isText(String? inputString, {bool isRequired = false}) {
  if (inputString?.trim().isEmpty ?? true) {
    return !isRequired;
  }
  final pattern = RegExp(r'^[a-zA-Z ]+$');
  return pattern.hasMatch(inputString!);
}

// Check if String is a valid email
bool isValidEmail(String? inputString, {bool isRequired = false}) {
  if (!isRequired && (inputString?.isEmpty ?? true)) {
    return true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(inputString);
  }
  return false;
}

// Check if String is a valid password
bool isValidPassword(String? inputString, {bool isRequired = false}) {
  if (!isRequired && (inputString?.isEmpty ?? true)) {
    return true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    const pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(inputString);
  }
  return false;
}
