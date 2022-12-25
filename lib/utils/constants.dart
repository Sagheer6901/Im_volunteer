const String vapidKey =
    'BObhGi6Xf3yREvhNqEjA64zuHuDryeX3Do8i32FLY-Yp4n87cDDFsTPjMNyQCI2nlD2_xJzWdsE-5R2XP2JLaCk';
const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

String? emailValidator(String? value) {
  if (value == null) {
    return 'Email is empty!';
  } else if (value == '') {
    return 'Email is empty!';
  } else if (!RegExp(emailRegex).hasMatch(value)) {
    return 'Email is invalid!';
  }
  return null;
}

final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

String? passwordValidator(String? value) {
  if (value == null) {
    return 'Password is empty!';
  } else if (value == '') {
    return 'Password is empty!';
  } else if (value.length < 6) {
    return 'Password can\'t be less than 6 characters';
  }
  return null;
}

String? stringValidator(String? value) {
  if (value == null) {
    return 'Field is empty!';
  } else if (value == '') {
    return 'Field is empty!';
  }
  return null;
}
