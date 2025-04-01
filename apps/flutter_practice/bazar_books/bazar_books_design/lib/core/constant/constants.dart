// api_constants.dart
import 'package:form_field_validator/form_field_validator.dart';

class Constants {
  static const String apiUrlProduct =
      "https://66dfe9422fb67ac16f278487.mockapi.io/api/v1/";

  static const String apiUrlVendor =
      "https://66e29593494df9a478e23cab.mockapi.io/api/v1/";

  static const String apiUrlAvatar =
      "https://i.pinimg.com/474x/fb/94/90/fb94901fd6080910a8eb531fda1baf6e.webp";

  static const String imgUrlDefault =
      'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp';

  static const String apiUrlAuthor =
      "https://66dfe9422fb67ac16f278487.mockapi.io/api/v1/";

  static const String apiUrlUser =
      'https://66e29593494df9a478e23cab.mockapi.io/api/v1/';

  static const String titleDefault = 'No Title';

  static const emailError = 'Enter a valid email address';
  static const requiredField = "This field is required";

  static final passwordValidator = MultiValidator(
    [
      RequiredValidator(errorText: 'Password is required'),
      MinLengthValidator(8,
          errorText: 'Password must be at least 8 digits long'),
      PatternValidator(r'(?=.*?[#?!@$%^&*-])',
          errorText: 'Passwords must have at least one special character'),
    ],
  ).call;

  static final emailValidator = MultiValidator(
    [
      RequiredValidator(errorText: Constants.requiredField),
      EmailValidator(errorText: Constants.emailError),
    ],
  ).call;

  static final nameValidator = MultiValidator(
    [
      RequiredValidator(errorText: Constants.requiredField),
      MinLengthValidator(2,
          errorText: 'Name must be at least 3 characters long'),
    ],
  ).call;

  static const noFavorites = 'No favorites added yet!';
}
