import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pratice_improve_flutter_form_builder/config/routes/app_pages.dart';
import 'package:pratice_improve_flutter_form_builder/data/constants/constants.dart';
import 'package:pratice_improve_flutter_form_builder/data/models/auth_model/api_user.dart';
import 'package:pratice_improve_flutter_form_builder/models/resume_file.dart';
import 'package:pratice_improve_flutter_form_builder/service/auth_storage_service.dart';

import '../models/application_model.dart';
import '../ui/application_form/application_form.dart';

class ApplicationController extends GetxController {
  final ApplicationModel application = ApplicationModel();

  // Form keys for validation
  final personalInfoFormKey = GlobalKey<FormBuilderState>();
  final additionalInfoFormKey = GlobalKey<FormBuilderState>();

  final isPersonalInfoFormValid = false.obs;
  final isAdditionalInfoFormValid = false.obs;
  final isSubmitting = false.obs;
  final isEditMode = false.obs;
  final AuthStorageService _authStorageService = AuthStorageService();

  void resetSignUpState() {
    application.currentStep.value = 0;
    application.fullName.value = '';
    application.phoneNumber.value = '';
    application.emailAddress.value = '';
    application.personalWebsite.value = '';
    application.portfolioUrl.value = '';
    application.coverLetter.value = '';
    application.resumeFiles.clear();
    isPersonalInfoFormValid.value = false;
    isAdditionalInfoFormValid.value = false;
    update();
    debugPrint('Sign-up state reset');
  }

  Future<void> logout() async {
    if (Get.isRegistered<ApplicationController>()) {
      Get.find<ApplicationController>().resetSignUpState();
    }

    await _authStorageService.clearSavedCredentials();

    Get.offAllNamed(Routes.login);
  }

  Future<void> editProfile(ApiUser user) async {
    isEditMode.value = true;

    application.userId.value = user.userId ?? '';
    application.fullName.value = user.name ?? '';
    application.emailAddress.value = user.email ?? '';
    application.phoneNumber.value = user.phoneNumber ?? '';
    application.personalWebsite.value = user.personalWebsite ?? '';
    application.portfolioUrl.value = user.portfolioUrl ?? '';
    application.coverLetter.value = user.coverLetter ?? '';

    goToStep(0);

    Get.to(() => const ApplicationForm());
  }

  void goToNextStep() {
    if (application.currentStep.value < 2) {
      application.currentStep.value++;
    }
  }

  void goToPreviousStep() {
    if (application.currentStep.value > 0) {
      application.currentStep.value--;
    }
  }

  void updatePersonalInfoFormButtonState() {
    isPersonalInfoFormValid.value =
        personalInfoFormKey.currentState?.isValid ?? false;
  }

  void updateAdditionalInfoFormButtonState() {
    final isFormValid = additionalInfoFormKey.currentState?.isValid ?? false;
    final isFileUploaded = application.resumeFiles.isNotEmpty;
    isAdditionalInfoFormValid.value = isFormValid && isFileUploaded;
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 2) {
      application.currentStep.value = step;
    }
  }

  Future<void> pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      const maxSizeInBytes = 12 * 1024 * 1024;
      if (file.size > maxSizeInBytes) {
        Get.snackbar(
          'File Too Large',
          'Maximum file size is 12MB. Please choose a smaller file.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.black,
        );
        return;
      }
      final newResume = ResumeFile(
        id: file.path!,
        name: file.name,
        size: file.size,
      );

      application.resumeFiles.add(newResume);

      updateAdditionalInfoFormButtonState();
    }
  }

  void removeResume(ResumeFile fileToRemove) {
    application.resumeFiles.remove(fileToRemove);
    updateAdditionalInfoFormButtonState();
  }

  bool validatePersonalInfoForm() {
    final isValid =
        personalInfoFormKey.currentState?.saveAndValidate() ?? false;
    isPersonalInfoFormValid.value = isValid;
    if (isValid) {
      final formValues = personalInfoFormKey.currentState!.value;
      application.fullName.value = formValues['fullName'] ?? '';
      application.phoneNumber.value = formValues['phoneNumber'] ?? '';
      application.emailAddress.value = formValues['emailAddress'] ?? '';
      application.personalWebsite.value = formValues['personalWebsite'] ?? '';
      application.portfolioUrl.value = formValues['portfolioUrl'] ?? '';

      // Update validation status for each field
      application.updateValidationStatus('fullName', true);
      application.updateValidationStatus('phoneNumber', true);
      application.updateValidationStatus('emailAddress', true);
      application.updateValidationStatus(
          'personalWebsite',
          application.personalWebsite.isEmpty ||
              application.personalWebsite.isNotEmpty);
      application.updateValidationStatus(
          'portfolioUrl',
          application.portfolioUrl.isEmpty ||
              application.portfolioUrl.isNotEmpty);
    }

    return isValid;
  }

  bool validateAdditionalInfoForm() {
    final isFormValid =
        additionalInfoFormKey.currentState?.saveAndValidate() ?? false;
    final isFileUploaded = application.resumeFiles.isNotEmpty;

    final isOverallValid = isFormValid && isFileUploaded;
    isAdditionalInfoFormValid.value = isOverallValid;

    if (isFormValid) {
      final formValues = additionalInfoFormKey.currentState!.value;
      application.coverLetter.value = formValues['coverLetter'] ?? '';
    }

    if (!isFileUploaded) {
      Get.snackbar('Missing Resume', 'Please upload at least one resume file.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
    return isOverallValid;
  }

  Future<void> updateUserProfile() async {
    isSubmitting.value = true;

    final credentials = await AuthStorageService().getSavedCredentials();
    final password = credentials['password'];

    final user = ApiUser(
      userId: application.userId.value,
      name: application.fullName.value,
      email: application.emailAddress.value,
      password: password,
      isLoggedIn: true,
      phoneNumber: application.phoneNumber.value,
      personalWebsite: application.personalWebsite.value,
      portfolioUrl: application.portfolioUrl.value,
      coverLetter: application.coverLetter.value,
    );

    final response = await http.put(
      Uri.parse('${Constants.apiUrlUser}user/${user.userId}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    debugPrint('Update response status: ${response.statusCode}');
    debugPrint('Update response body: ${response.body}');
    isSubmitting.value = false;

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Profile updated successfully');
      Get.offAllNamed(Routes.home);
    } else {
      Get.snackbar('Error', 'Failed to update profile');
    }
  }

  Future<bool> submitApplication() async {
    if (!isPersonalInfoFormValid.value || !isAdditionalInfoFormValid.value) {
      debugPrint('Cannot submit: Not all steps are valid.');

      Get.snackbar(
        'Incomplete Application',
        'Please review all steps and ensure information is complete and valid.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isSubmitting.value = true;
    debugPrint('--- Submitting Application Data ---');
    debugPrint('Full Name: ${application.fullName.value}');
    debugPrint('Phone Number: ${application.phoneNumber.value}');
    debugPrint('Email Address: ${application.emailAddress.value}');
    debugPrint('Personal Website: ${application.personalWebsite.value}');
    debugPrint('Portfolio URL: ${application.portfolioUrl.value}');
    debugPrint('Cover Letter: ${application.coverLetter.value}');
    debugPrint('---------------------------------');

    final user = ApiUser(
      userId: application.emailAddress.value,
      name: application.fullName.value,
      email: application.emailAddress.value,
      password: application.phoneNumber.value,
      isLoggedIn: true,
      phoneNumber: application.phoneNumber.value,
      personalWebsite: application.personalWebsite.value,
      portfolioUrl: application.portfolioUrl.value,
      coverLetter: application.coverLetter.value,
    );

    final response = await http.post(
      Uri.parse('${Constants.apiUrlUser}user'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 201) {
      debugPrint('Application submitted successfully.');

      await AuthStorageService().saveLoginCredentials(
        email: user.email!,
        password: user.password!,
      );

      Get.offAllNamed(Routes.home);

      isSubmitting.value = false;
      return true;
    } else {
      debugPrint('Failed to submit application: ${response.body}');
      Get.snackbar(
        'Error',
        'Failed to submit the application. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      isSubmitting.value = false;
      return false;
    }
  }
}
