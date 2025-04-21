import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:online_books_app/data/constants/constants.dart';
import 'package:online_books_app/data/models/auth_model/api_user.dart';
import 'package:online_books_app/data/network/error_handler.dart';
import 'package:online_books_app/presentation/auth/signup/model/signup_model.dart';
import 'package:online_books_app/routes/app_routes.dart';

class SignupController extends GetxController {
  // TextEditingControllers
  TextEditingController firstNameInputController = TextEditingController();
  TextEditingController lastNameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  late final TextEditingController dayController;
  late final TextEditingController monthController;
  late final TextEditingController yearController;
  final ageController = TextEditingController();
  final schoolNameController = TextEditingController();
  final schoolIdController = TextEditingController();
  final formKey = GlobalKey<FormBuilderState>();

  // FocusNodes
  final FocusNode dayFocusNode = FocusNode();
  final FocusNode monthFocusNode = FocusNode();
  final FocusNode yearFocusNode = FocusNode();

  final Dio _dio = Dio();

  Rx<SignupModel> signupModelObj = SignupModel().obs;
  Rx<bool> isShowPassword = true.obs;
  Rx<bool> termAgreementCheckBox = false.obs;
  RxBool isStudent = false.obs;
  Rx<bool> isLoading = false.obs;

  // Observable variables
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxString day = ''.obs;
  final RxString month = ''.obs;
  final RxString year = ''.obs;
  final Rx<DateTime?> selectedDateOfBirth = Rx<DateTime?>(null);
  final RxInt age = 0.obs;

  // Error states
  final RxString dayError = RxString('');
  final RxString monthError = RxString('');
  final RxString yearError = RxString('');
  final RxString schoolNameError = RxString('');
  final RxString schoolIdError = RxString('');
  final RxString firstNameError = RxString('');
  final RxString lastNameError = RxString('');
  final RxString emailError = RxString('');
  final RxString passwordError = RxString('');

  bool _isUpdatingFromDatePicker = false;
  bool _isUpdatingFromTextFields = false;

  final ScrollController scrollController = ScrollController();
  final GlobalKey occupationDropdownKey = GlobalKey();

  // Computed property to check if all fields are valid
  bool get isFormValid {
    return firstNameError.value.isEmpty &&
        lastNameError.value.isEmpty &&
        emailError.value.isEmpty &&
        dayError.value.isEmpty &&
        monthError.value.isEmpty &&
        yearError.value.isEmpty &&
        (isStudent.value
            ? (schoolNameError.value.isEmpty && schoolIdError.value.isEmpty)
            : true) &&
        termAgreementCheckBox.value &&
        passwordInputController.text.length >= 6;
  }

  void ensureDropdownVisible(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.4,
        );
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    dayController = TextEditingController();
    monthController = TextEditingController();
    yearController = TextEditingController();

    day.value = '';
    month.value = '';
    year.value = '';
    age.value = 0;
    isStudent.value = false;
    schoolNameError.value = '';
    schoolIdError.value = '';

    selectedDate.value = null;
    selectedDateOfBirth.value = null;
  }

  @override
  void onClose() {
    // Dispose controllers when the widget is removed
    scrollController.dispose();
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    firstNameInputController.dispose();
    lastNameInputController.dispose();
    emailInputController.dispose();
    passwordInputController.dispose();
    ageController.dispose();
    schoolNameController.dispose();
    schoolIdController.dispose();

    // Dispose FocusNodes
    dayFocusNode.dispose();
    monthFocusNode.dispose();
    yearFocusNode.dispose();

    super.onClose();
  }

  // Update text fields from date without triggering circular updates
  void updateTextFieldsFromDate(DateTime date) {
    if (_isUpdatingFromTextFields) return;

    _isUpdatingFromDatePicker = true;

    day.value = date.day.toString().padLeft(2, '0');
    month.value = date.month.toString().padLeft(2, '0');
    year.value = date.year.toString();

    dayController.text = day.value;
    monthController.text = month.value;
    yearController.text = year.value;

    calculateAge(date);

    // Clear any errors
    dayError.value = '';
    monthError.value = '';
    yearError.value = '';

    _isUpdatingFromDatePicker = false;
  }

  // Validate day input
  bool validateDay(String value) {
    // Clear previous error
    dayError.value = '';

    if (value.isEmpty) {
      dayError.value = 'Required';
      return false;
    }

    int? dayValue = int.tryParse(value);
    if (dayValue == null) {
      dayError.value = 'Invalid';
      return false;
    }

    if (dayValue < 1 || dayValue > 31) {
      dayError.value = 'Range: 1-31';
      return false;
    }

    // Check if day is valid for the current month and year
    int yearValue = int.tryParse(year.value) ?? DateTime.now().year;
    int monthValue = int.tryParse(month.value) ?? DateTime.now().month;

    try {
      DateTime(yearValue, monthValue, dayValue);
    } catch (e) {
      dayError.value = 'Invalid for month';
      return false;
    }

    return true;
  }

  // Validate month input
  bool validateMonth(String value) {
    // Clear previous error
    monthError.value = '';

    if (value.isEmpty) {
      monthError.value = 'Required';
      return false;
    }

    int? monthValue = int.tryParse(value);
    if (monthValue == null) {
      monthError.value = 'Invalid';
      return false;
    }

    if (monthValue < 1 || monthValue > 12) {
      monthError.value = 'Range: 1-12';
      return false;
    }

    return true;
  }

  // Validate year input
  bool validateYear(String value) {
    // Clear previous error
    yearError.value = '';

    if (value.isEmpty) {
      yearError.value = 'Required';
      return false;
    }

    int? yearValue = int.tryParse(value);
    if (yearValue == null) {
      yearError.value = 'Invalid';
      return false;
    }

    if (yearValue < 1900 || yearValue > DateTime.now().year) {
      yearError.value = 'Range: 1900-Now';
      return false;
    }

    return true;
  }

  // Update date from text fields without triggering circular updates
  void updateDateFromTextFields() {
    if (_isUpdatingFromDatePicker) return;

    // Skip if any field is empty
    if (day.value.isEmpty || month.value.isEmpty || year.value.isEmpty) {
      selectedDate.value = null;
      selectedDateOfBirth.value = null;
      age.value = 0;
      return;
    }

    _isUpdatingFromTextFields = true;

    // Get values from fields with validation
    final dayValue = int.tryParse(day.value);
    final monthValue = int.tryParse(month.value);
    final yearValue = int.tryParse(year.value);

    // Check if all values are valid numbers
    if (dayValue == null || monthValue == null || yearValue == null) {
      selectedDate.value = null;
      selectedDateOfBirth.value = null;
      age.value = 0;
      _isUpdatingFromTextFields = false;
      return;
    }

    // Create a new date, handling invalid dates
    try {
      final newDate = DateTime(yearValue, monthValue, dayValue);
      selectedDate.value = newDate;
      selectedDateOfBirth.value = newDate;
      calculateAge(newDate);
    } catch (e) {
      selectedDate.value = null;
      selectedDateOfBirth.value = null;
      age.value = 0;
    }

    _isUpdatingFromTextFields = false;
  }

  String? validateSchoolName(String? value) {
    if (isStudent.value && (value == null || value.isEmpty)) {
      return 'Please enter school name';
    }
    return null;
  }

  String? validateSchoolId(String? value) {
    if (isStudent.value && (value == null || value.isEmpty)) {
      return 'Please enter school ID';
    }
    return null;
  }

  void calculateAge(DateTime? birthDate) {
    if (birthDate == null) {
      age.value = 0;
      return;
    }
    DateTime now = DateTime.now();
    int calculatedAge = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      calculatedAge--;
    }
    age.value = calculatedAge;
  }

  Future<void> signUp() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    String firstName = firstNameInputController.text;
    String lastName = lastNameInputController.text;
    String email = emailInputController.text;
    String password = passwordInputController.text;

    String name = '$firstName $lastName';

    bool emailExists = await isEmailExist(email);
    if (emailExists) {
      Get.snackbar("Email already exists", "This email is already in use.");
      return;
    }

    isLoading.value = true;

    try {
      ApiUser? user = await signUpAPI(name, email, password);

      if (user != null) {
        Get.snackbar("Success", "Account created successfully!");
        Get.offAllNamed(AppRoutes.homeInitialPage);
      } else {
        Get.snackbar("Sign Up Failed", "Error creating account");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again later.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<ApiUser?> signUpAPI(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '${Constants.apiUrlUser}user',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        return ApiUser.fromJson(response.data);
      } else {
        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
        );
      }
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  Future<bool> isEmailExist(String email) async {
    try {
      final response = await _dio.get(
        '${Constants.apiUrlUser}user?email=$email',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.isNotEmpty;
      }

      return false;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return false;
      }
      throw ErrorHandler.handle(e).failure;
    }
  }

  // Validate first name input
  bool validateFirstName(String value) {
    firstNameError.value = '';

    if (value.isEmpty) {
      firstNameError.value = 'Required';
      return false;
    }

    if (value.length < 2) {
      firstNameError.value = 'Too short';
      return false;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      firstNameError.value = 'Only letters allowed';
      return false;
    }

    return true;
  }

  // Validate last name input
  bool validateLastName(String value) {
    lastNameError.value = '';

    if (value.isEmpty) {
      lastNameError.value = 'Required';
      return false;
    }

    if (value.length < 2) {
      lastNameError.value = 'Too short';
      return false;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      lastNameError.value = 'Only letters allowed';
      return false;
    }

    return true;
  }

  // Validate email input
  bool validateEmail(String value) {
    emailError.value = '';

    if (value.isEmpty) {
      emailError.value = 'Required';
      return false;
    }

    if (!GetUtils.isEmail(value)) {
      emailError.value = 'Invalid email format';
      return false;
    }

    return true;
  }

  // Validate password input
  bool validatePassword(String value) {
    passwordError.value = '';

    if (value.isEmpty) {
      passwordError.value = 'Required';
      return false;
    }

    if (value.length < 8) {
      passwordError.value = 'Password must be at least 8 characters';
      return false;
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      passwordError.value =
          'Password must contain at least one lowercase letter';
      return false;
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      passwordError.value = 'Password must contain at least one number';
      return false;
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      passwordError.value =
          'Password must contain at least one special character';
      return false;
    }

    return true;
  }
}
