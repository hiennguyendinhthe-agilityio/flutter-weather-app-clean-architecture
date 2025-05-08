import 'package:get/get.dart';
import 'package:pratice_improve_flutter_form_builder/models/resume_file.dart';

class ApplicationModel {
  // Personal information
  final RxString fullName = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxString emailAddress = ''.obs;
  final RxString personalWebsite = ''.obs;
  final RxString portfolioUrl = ''.obs;
  RxString userId = ''.obs;

  // Additional information
  final RxString coverLetter = ''.obs;

  var resumeFiles = RxList<ResumeFile>([]);
  // Form validation status
  final RxBool isPersonalInfoValid = false.obs;
  final RxBool isAdditionalInfoValid = false.obs;

  // Current step
  final RxInt currentStep = 0.obs;

  // Validation status for each field
  final RxMap<String, bool> validationStatus = <String, bool>{}.obs;
  bool get isResumeUploaded => resumeFiles.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'personalInfo': {
        'fullName': fullName.value,
        'phoneNumber': phoneNumber.value,
        'emailAddress': emailAddress.value,
        'personalWebsite': personalWebsite.value,
        'portfolioUrl': portfolioUrl.value,
      },
      'additionalInfo': {
        'coverLetter': coverLetter.value,
        'resumes': resumeFiles
            .map((file) =>
                {'name': file.name, 'size': file.size, 'path': file.id})
            .toList(),
      }
    };
  }
}
