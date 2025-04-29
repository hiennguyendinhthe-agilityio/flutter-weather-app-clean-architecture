import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:pratice_improve_flutter_form_builder/models/resume_file.dart';

import '../models/application_model.dart';

class ApplicationController extends GetxController {
  final ApplicationModel application = ApplicationModel();

  // Form keys for validation
  final personalInfoFormKey = GlobalKey<FormBuilderState>();
  final additionalInfoFormKey = GlobalKey<FormBuilderState>();

  final isPersonalInfoFormValid = false.obs;
  final isAdditionalInfoFormValid = false.obs;
  final isSubmitting = false.obs;

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
    // Cập nhật lại trạng thái nút bấm
    updateAdditionalInfoFormButtonState();
  }

  bool validatePersonalInfoForm() {
    final isValid =
        personalInfoFormKey.currentState?.saveAndValidate() ?? false;
    isPersonalInfoFormValid.value = isValid;
    if (isValid) {
      // Update model with form values
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
    if (application.resumeFiles.isEmpty) {
      debugPrint('Resumes: None');
    } else {
      debugPrint('Resumes:');
      for (var file in application.resumeFiles) {
        debugPrint(
            '  - Name: ${file.name}, Size: ${file.size}, Path: ${file.id}');
      }
    }
    try {
      debugPrint('Simulating API call...');
      await Future.delayed(const Duration(seconds: 2));
      debugPrint('API call simulation finished.');

      isSubmitting.value = false;

      Get.dialog(
          AlertDialog(
            title: const Text('Application Submitted'),
            content:
                const Text('Your application has been submitted successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('OK'),
              ),
            ],
          ),
          barrierDismissible: false);

      return true;
    } catch (e) {
      debugPrint('Error submitting application: $e');
      isSubmitting.value = false;

      Get.dialog(
        AlertDialog(
          title: const Text('Submission Failed'),
          content: Text(
              'There was an error submitting your application: $e. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      return false;
    }
  }
}
