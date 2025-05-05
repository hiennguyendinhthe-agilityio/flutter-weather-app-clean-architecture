import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pratice_improve_flutter_form_builder/controllers/application_controller.dart';

class StepIndicator extends StatelessWidget {
  final ApplicationController controller;

  const StepIndicator({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentStep = controller.application.currentStep.value;
      final isPersonalValid = controller.isPersonalInfoFormValid.value;
      final isAdditionalValid = controller.isAdditionalInfoFormValid.value;
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Color(0xFFF2F3F5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStep(context, 0, 'Personal', currentStep, isPersonalValid),
            _buildDivider(context),
            _buildStep(
                context, 1, 'Additional', currentStep, isAdditionalValid),
            _buildDivider(context),
            _buildStep(context, 2, 'Review', currentStep, true),
          ],
        ),
      );
    });
  }

  Widget _buildStep(BuildContext context, int step, String label,
      int currentStep, bool isValid) {
    final theme = Theme.of(context);
    final isActive = step == currentStep;
    final isCompleted = step < currentStep && isValid;

    Color circleColor;
    Color textColor;

    if (isActive) {
      circleColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.primary;
    } else if (isCompleted) {
      circleColor = theme.colorScheme.secondary;
      textColor = theme.colorScheme.secondary;
    } else {
      circleColor = theme.disabledColor;
      textColor = theme.disabledColor;
    }

    return GestureDetector(
      onTap: () {
        if (step <= currentStep) {
          controller.goToStep(step);
        }
      },
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? Text(
                      '${step + 1}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      '${step + 1}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 40,
      height: 1,
      color: Theme.of(context).dividerColor,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
