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

  final personalInfoFormKey = GlobalKey<FormBuilderState>();
  final additionalInfoFormKey = GlobalKey<FormBuilderState>();

  final isPersonalInfoFormValid = false.obs;
  final isAdditionalInfoFormValid = false.obs;
  final isSubmitting = false.obs;
  final isEditMode = false.obs;
  final AuthStorageService _authStorageService = AuthStorageService();

  final RxBool canUndoPersonalInfo = false.obs;
  final RxBool canUndoAdditionalInfo = false.obs;

  Map<String, dynamic>? personalInfoInitialState;
  Map<String, dynamic>? additionalInfoInitialState;
  List<ResumeFile>? _initialResumeFiles;
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

    canUndoAdditionalInfo.value = false;
    canUndoPersonalInfo.value = false;
    personalInfoInitialState = null;
    additionalInfoInitialState = null;

    update();
    debugPrint('Sign-up state reset');
  }

  void captureInitialStateForStep(int step) {
    if (isEditMode.value) return;

    if (step == 0 && personalInfoInitialState == null) {
      personalInfoInitialState = {
        'fullName': application.fullName.value,
        'phoneNumber': application.phoneNumber.value,
        'emailAddress': application.emailAddress.value,
        'personalWebsite': application.personalWebsite.value,
        'portfolioUrl': application.portfolioUrl.value,
      };
      debugPrint(
          'Controller: Initial state CAPTURED for NEW personal info: $personalInfoInitialState');
      canUndoPersonalInfo.value = false;
    } else if (step == 1 && additionalInfoInitialState == null) {
      if (additionalInfoFormKey.currentState != null) {
        additionalInfoInitialState = Map<String, dynamic>.from(
            additionalInfoFormKey.currentState!.value);
        debugPrint(
            'Controller: Initial state CAPTURED for NEW additional info: $additionalInfoInitialState');
      } else {
        additionalInfoInitialState = {
          'coverLetter': application.coverLetter.value,
        };
      }
      _initialResumeFiles = List<ResumeFile>.from(application.resumeFiles);
      debugPrint(
          'Controller: Initial state CAPTURED for NEW resume files: $_initialResumeFiles');
      canUndoAdditionalInfo.value = false;
    }
  }

  void updateUndoButtonState(FormBuilderState? formState,
      Map<String, dynamic>? initialStateMap, RxBool canUndo) {
    debugPrint("--- updateUndoButtonState CALLED ---");
    if (formState == null) {
      debugPrint("updateUndoButtonState: formState is NULL");
      canUndo.value = false;
      return;
    }
    if (initialStateMap == null) {
      debugPrint("updateUndoButtonState: initialStateMap is NULL");
      canUndo.value = false;
      return;
    }

    final currentState = Map<String, dynamic>.from(formState.value);
    final initialState = Map<String, dynamic>.from(initialStateMap);

    debugPrint(
        "updateUndoButtonState: Initial State to compare: $initialState");
    debugPrint(
        "updateUndoButtonState: Current State to compare: $currentState");

    bool hasChanges = false;

    if (currentState.length != initialState.length) {
      debugPrint(
          "updateUndoButtonState: Lengths are different. Current: ${currentState.length}, Initial: ${initialState.length}");
      hasChanges = true;
    } else {
      for (final key in initialState.keys) {
        if (!currentState.containsKey(key)) {
          debugPrint(
              "updateUndoButtonState: Key '$key' in initial but MISSING in current.");
          hasChanges = true;
          break;
        }

        final initialValue = initialState[key];
        final currentValue = currentState[key];
        bool fieldChanged = false;

        if (initialValue == null && currentValue != null) {
          fieldChanged = true;
        } else if (initialValue != null && currentValue == null) {
          fieldChanged = true;
        } else if (initialValue != null && currentValue != null) {
          if (initialValue != currentValue) {
            if (initialValue is List && currentValue is List) {
              if (initialValue.length != currentValue.length) {
                fieldChanged = true;
              } else {
                for (int i = 0; i < initialValue.length; i++) {
                  if (initialValue[i] != currentValue[i]) {
                    fieldChanged = true;
                    break;
                  }
                }
              }
            } else {
              fieldChanged = true;
            }
          }
        }

        if (fieldChanged) {
          debugPrint(
              "updateUndoButtonState: CHANGE DETECTED for key '$key': initialValue='$initialValue' (Type: ${initialValue?.runtimeType}), currentValue='$currentValue' (Type: ${currentValue?.runtimeType})");
          hasChanges = true;
          break; // Thoát sớm
        }
      }
    }

    if (canUndo == canUndoAdditionalInfo) {
      final initialFiles = _initialResumeFiles ?? [];
      final currentFiles = application.resumeFiles.toList();
      if (initialFiles.length != currentFiles.length) {
        debugPrint(
            "updateUndoButtonState: Resume files count changed. Initial: ${initialFiles.length}, Current: ${currentFiles.length}");
        hasChanges = true;
      } else {
        for (int i = 0; i < initialFiles.length; i++) {
          if (initialFiles[i].id != currentFiles[i].id) {
            debugPrint(
                "updateUndoButtonState: Resume file at index $i changed.");
            hasChanges = true;
            break;
          }
        }
      }
    }

    canUndo.value = hasChanges;
    debugPrint("updateUndoButtonState: Result -> hasChanges = $hasChanges");
    debugPrint("------------------------------------");
  }

  void undoPersonalInfoChanges() {
    debugPrint("--- undoPersonalInfoChanges ---");
    debugPrint("Value of personalInfoInitialState: $personalInfoInitialState");
    debugPrint(
        " Value of personalInfoFormKey.currentState: ${personalInfoFormKey.currentState != null}");

    if (personalInfoInitialState != null &&
        personalInfoFormKey.currentState != null) {
      debugPrint(
          "Value of personalInfoInitialState: $personalInfoInitialState");
      personalInfoFormKey.currentState?.patchValue(personalInfoInitialState!);

      debugPrint(
          "Called patchValue. New value: ${personalInfoFormKey.currentState?.value}");

      updateUndoButtonState(personalInfoFormKey.currentState,
          personalInfoInitialState, canUndoPersonalInfo);
      updatePersonalInfoFormButtonState();
    } else {
      debugPrint(
          "Can't undo: personalInfoInitialState is NULL or formKey.currentState is NULL");
    }
    debugPrint("--- The end of undoPersonalInfoChanges ---");
  }

  void undoAdditionalInfoChanges() {
    if (additionalInfoInitialState != null &&
        additionalInfoFormKey.currentState != null) {
      additionalInfoFormKey.currentState
          ?.patchValue(additionalInfoInitialState!);
      if (_initialResumeFiles != null) {
        application.resumeFiles
            .assignAll(List<ResumeFile>.from(_initialResumeFiles!));
      }

      updateAdditionalInfoFormButtonState();
      updateUndoButtonState(additionalInfoFormKey.currentState,
          additionalInfoInitialState, canUndoAdditionalInfo);
      debugPrint('Undo additional info changes');
    }
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

    personalInfoInitialState = {};
    additionalInfoInitialState = {};
    _initialResumeFiles = [];

    application.userId.value = user.userId ?? '';
    application.fullName.value = user.name ?? '';
    application.emailAddress.value = user.email ?? '';
    application.phoneNumber.value = user.phoneNumber ?? '';
    application.personalWebsite.value = user.personalWebsite ?? '';
    application.portfolioUrl.value = user.portfolioUrl ?? '';
    application.coverLetter.value = user.coverLetter ?? '';

    goToStep(0);

    Get.to(() => const ApplicationForm());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      personalInfoFormKey.currentState?.patchValue({
        'fullName': application.fullName.value,
        'phoneNumber': application.phoneNumber.value,
        'emailAddress': application.emailAddress.value,
        'personalWebsite': application.personalWebsite.value,
        'portfolioUrl': application.portfolioUrl.value,
      });
      _initialResumeFiles = List<ResumeFile>.from(application.resumeFiles);
      debugPrint(
          'EDIT MODE (AdditionalInfo): _initialResumeFiles CAPTURED: $_initialResumeFiles');
      canUndoAdditionalInfo.value = false;
      additionalInfoFormKey.currentState?.patchValue({
        'coverLetter': application.coverLetter.value,
      });

      if (personalInfoFormKey.currentState != null) {
        Map<String, dynamic> capturedValues =
            personalInfoFormKey.currentState!.value;
        debugPrint(
            "EDIT MODE (PersonalInfo): Raw values from formKey.currentState.value: $capturedValues");
        capturedValues.forEach((key, value) {
          debugPrint(
              "EDIT MODE (PersonalInfo) Key: '$key', Value: '$value', Type: ${value.runtimeType}");
        });
        personalInfoInitialState = Map<String, dynamic>.from(capturedValues);
        debugPrint(
            'EDIT MODE (PersonalInfo): personalInfoInitialState CAPTURED: $personalInfoInitialState');
        canUndoPersonalInfo.value = false;
      }

      if (additionalInfoFormKey.currentState != null) {
        Map<String, dynamic> capturedAdditionalValues =
            additionalInfoFormKey.currentState!.value;
        debugPrint(
            "EDIT MODE (AdditionalInfo): Raw values from formKey.currentState.value: $capturedAdditionalValues");
        additionalInfoInitialState =
            Map<String, dynamic>.from(capturedAdditionalValues);
        debugPrint(
            'EDIT MODE (AdditionalInfo): additionalInfoInitialState CAPTURED: $additionalInfoInitialState');

        _initialResumeFiles = List<ResumeFile>.from(application.resumeFiles);
        debugPrint(
            'EDIT MODE (AdditionalInfo): _initialResumeFiles CAPTURED: $_initialResumeFiles');
        canUndoAdditionalInfo.value = false;
      }
      debugPrint(
          'Controller: Initial state SET for EDIT personal info: $personalInfoInitialState');
    });
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

      debugPrint('Current step updated to: ${application.currentStep.value}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        captureInitialStateForStep(step);
      });
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
      updateUndoButtonState(additionalInfoFormKey.currentState,
          additionalInfoInitialState, canUndoAdditionalInfo);
    }
  }

  void removeResume(ResumeFile fileToRemove) {
    application.resumeFiles.remove(fileToRemove);
    updateAdditionalInfoFormButtonState();
    updateUndoButtonState(additionalInfoFormKey.currentState,
        additionalInfoInitialState, canUndoAdditionalInfo);
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
      canUndoPersonalInfo.value = false;
      canUndoAdditionalInfo.value = false;
      personalInfoInitialState = null;
      additionalInfoInitialState = null;
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
      canUndoPersonalInfo.value = false;
      canUndoAdditionalInfo.value = false;
      personalInfoInitialState = null;
      additionalInfoInitialState = null;
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
