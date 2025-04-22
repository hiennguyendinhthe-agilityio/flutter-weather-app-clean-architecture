import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormController extends GetxController {
  static var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;
  var website = ''.obs;
  var phoneNumber = ''.obs;
  var helpDescription = ''.obs;
  var teamSize = 10.0.obs;
  var budget = 1000.0.obs;
  var selectedServices = <String>[].obs;
  var isSecondFormValid = false.obs;
  var teamSizeRange = RangeValues(10, 15).obs;
  var budgetRange = RangeValues(1000, 2500).obs;
  var selectedTools = <String>[].obs;

  final List<ServiceOptionConfig> serviceOptionsConfig = const [
    ServiceOptionConfig(
        value: "Web Design", title: "Web Design", icon: Icons.web),
    ServiceOptionConfig(
        value: "UI/UX Design",
        title: "UI/UX Design",
        icon: Icons.design_services),
    ServiceOptionConfig(
        value: "App Design", title: "App Design", icon: Icons.smartphone),
    ServiceOptionConfig(
        value: "Development", title: "Development", icon: Icons.code),
    ServiceOptionConfig(
        value: "Technical SEO", title: "Technical SEO", icon: Icons.search),
    ServiceOptionConfig(
        value: "Content Writing",
        title: "Content Writing",
        icon: Icons.edit_document),
    ServiceOptionConfig(
        value: "Strategy", title: "Strategy", icon: Icons.lightbulb_outline),
    ServiceOptionConfig(
        value: "Research", title: "Research", icon: Icons.search),
    ServiceOptionConfig(value: "Other", title: "Other", icon: Icons.more_horiz),
  ];

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final helpDescriptionController = TextEditingController();
  var isFirstFormValid = false.obs;

  late FocusNode firstNameFocusNode;
  late FocusNode lastNameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode websiteFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode helpDescriptionFocusNode;

  void updateFirstName(String value) => firstName.value = value;
  void updateLastName(String value) => lastName.value = value;
  void updateEmail(String value) => email.value = value;
  void updateWebsite(String value) => website.value = value;
  void updatePhoneNumber(String value) => phoneNumber.value = value;
  void updateHelpDescription(String value) => helpDescription.value = value;

  @override
  void onInit() {
    super.onInit();

    firstNameFocusNode = FocusNode();
    lastNameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    websiteFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    helpDescriptionFocusNode = FocusNode();

    firstNameController.addListener(() {
      firstName.value = firstNameController.text;
      _validateFormQuietly();
    });

    lastNameController.addListener(() {
      lastName.value = lastNameController.text;
      _validateFormQuietly();
    });

    emailController.addListener(() {
      email.value = emailController.text;
      _validateFormQuietly();
    });

    websiteController.addListener(() {
      website.value = websiteController.text;
      _validateFormQuietly();
    });

    helpDescriptionController.addListener(() {
      helpDescription.value = helpDescriptionController.text;
    });
  }

  @override
  void onClose() {
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    websiteFocusNode.dispose();
    phoneFocusNode.dispose();
    helpDescriptionFocusNode.dispose();

    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    websiteController.dispose();
    helpDescriptionController.dispose();
    super.onClose();
  }

  void setFieldTouched(String fieldName, bool touched) {
    _validateFormQuietly();
  }

  void _validateFormQuietly() {
    bool isValid = firstName.value.isNotEmpty &&
        lastName.value.isNotEmpty &&
        GetUtils.isEmail(email.value) &&
        (website.value.isEmpty ||
            GetUtils.isURL(website
                .value)); // Website is optional but must be valid if present

    if (isFirstFormValid.value != isValid) {
      isFirstFormValid.value = isValid;
    }
  }

  void toggleService(String service) {
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }
    validateSecondForm();
  }

  void updateBudgetRange(RangeValues values) {
    budgetRange.value = values;
    validateSecondForm();
  }

  void updateTeamSizeRange(RangeValues values) {
    teamSizeRange.value = values;
    isSecondFormValid.value =
        selectedServices.isNotEmpty && selectedTools.isNotEmpty;
  }

  void validateSecondForm() {
    isSecondFormValid.value =
        selectedServices.isNotEmpty && selectedTools.isNotEmpty;
  }

  void submitForm() {
    final theme = Get.theme;
    debugPrint('Form submitted with the following data:');
    debugPrint('First Name: ${firstName.value}');
    debugPrint('Last Name: ${lastName.value}');
    debugPrint('Email: ${email.value}');
    debugPrint('Website: ${website.value}');
    debugPrint('Phone Number: ${phoneNumber.value}');
    debugPrint('Help Description: ${helpDescription.value}');
    debugPrint(
        'Team Size: ${teamSizeRange.value.start}-${teamSizeRange.value.end}');
    debugPrint(
        'Budget: \$${budgetRange.value.start.toInt()}-\$${budgetRange.value.end.toInt()}');
    debugPrint('Selected Services: ${selectedServices.join(', ')}');

    debugPrint('Selected Tools: ${selectedTools.join(', ')}');

    Get.snackbar(
      'Success!',
      'Your form has been submitted successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: theme.colorScheme.primary,
      colorText: theme.colorScheme.onPrimary,
    );
  }
}

class ServiceOptionConfig {
  final String value;
  final String title;
  final IconData icon;

  const ServiceOptionConfig({
    required this.value,
    required this.title,
    required this.icon,
  });
}
