import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pratice_improve_flutter_form_builder/controllers/application_controller.dart';
import 'package:pratice_improve_flutter_form_builder/ui/application_form/step_indicator.dart';
import 'package:pratice_improve_flutter_form_builder/ui/screens/auth/sign_up/additional_info_screen.dart';
import 'package:pratice_improve_flutter_form_builder/ui/screens/auth/sign_up/personal_info_screen.dart';
import 'package:pratice_improve_flutter_form_builder/ui/screens/auth/sign_up/review_screen.dart';

class ApplicationForm extends StatelessWidget {
  const ApplicationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApplicationController>();

    return Scaffold(
      appBar: _customAppBar(controller, context),
      body: Column(
        children: [
          StepIndicator(controller: controller),
          Expanded(
            child: Obx(() {
              final currentStep = controller.application.currentStep.value;

              switch (currentStep) {
                case 0:
                  return PersonalInfoScreen(controller: controller);
                case 1:
                  return AdditionalInfoScreen(controller: controller);
                case 2:
                  return ReviewScreen(controller: controller);
                default:
                  return PersonalInfoScreen(controller: controller);
              }
            }),
          ),
          Obx(() {
            final currentStep = controller.application.currentStep.value;
            bool isButtonEnabled = false;
            VoidCallback? onPressedAction;
            String buttonText = 'Continue';

            switch (currentStep) {
              case 0: // Personal Info
                isButtonEnabled = controller.isPersonalInfoFormValid.value;
                onPressedAction = isButtonEnabled
                    ? () {
                        if (controller.validatePersonalInfoForm()) {
                          controller.goToNextStep();
                        }
                      }
                    : null;
                break;
              case 1: // Additional Info
                isButtonEnabled = controller.isAdditionalInfoFormValid.value;
                onPressedAction = isButtonEnabled
                    ? () {
                        if (controller.validateAdditionalInfoForm()) {
                          controller.goToNextStep();
                        }
                      }
                    : null;
                break;
              case 2:
                isButtonEnabled = true;
                buttonText = controller.isEditMode.value ? 'Save' : 'Submit';
                onPressedAction = () async {
                  if (controller.isEditMode.value) {
                    await controller.updateUserProfile();
                  } else {
                    await controller.submitApplication();
                  }
                };
                break;
            }

            if (onPressedAction != null || currentStep < 2) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPressedAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isButtonEnabled
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(128),
                      foregroundColor: isButtonEnabled
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withAlpha(204),
                      disabledBackgroundColor:
                          Theme.of(context).colorScheme.primary.withAlpha(77),
                      disabledForegroundColor: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withAlpha(153),
                    ),
                    child: Text(buttonText),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  AppBar _customAppBar(ApplicationController controller, BuildContext context) {
    return AppBar(
      leading: Obx(() => controller.application.currentStep.value > 0
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: controller.goToPreviousStep,
            )
          : const SizedBox.shrink()),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor:
                Theme.of(context).colorScheme.primary.withAlpha(25),
            child: Image.network(
              'https://assets-global.website-files.com/6257adef93867e50d84d30e2/636e0a6a49cf127bf92de1e2_icon_clyde_blurple_RGB.png',
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sr. Web designer',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Discord',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }
}
