// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:practice_flutter_form_builder/widgets/service_option.dart';

import '../controllers/form_controller.dart';

class ScreenTwo extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final FormController formController = Get.find<FormController>();

  ScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeaderSection(),
                  const SizedBox(height: 32),
                  _TeamSizeSection(controller: formController),
                  const SizedBox(height: 32),
                  _BudgetSection(controller: formController),
                  const SizedBox(height: 16),
                  _ServiceSelectionGrid(controller: formController),
                  const SizedBox(height: 32),
                  _ToolSelectionGroup(controller: formController),
                  const SizedBox(height: 32),
                  _BottomNavigation(
                    controller: formController,
                    formKey: _formKey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.handshake_outlined,
            color: theme.colorScheme.onPrimary,
            size: 24,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Let's work together",
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "We're a full-service agency dedicated to helping you go from MVP to industry leader. Let our team bring your goals to life.",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _TeamSizeSection extends StatelessWidget {
  final FormController controller;
  const _TeamSizeSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Team size*",
              style: theme.textTheme.titleMedium,
            ),
            Obx(
              () => Text(
                "${controller.teamSizeRange.value.start.toInt()}-${controller.teamSizeRange.value.end.toInt()} people",
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(
          () => FormBuilderRangeSlider(
            displayValues: DisplayValues.none,
            name: 'teamSizeRange',
            min: 10,
            max: 20,
            initialValue: controller.teamSizeRange.value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (values) {
              if (values != null) {
                controller.updateTeamSizeRange(values);
              }
            },
          ),
        ),
      ],
    );
  }
}

class _BudgetSection extends StatelessWidget {
  final FormController controller;
  const _BudgetSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Budget*",
              style: theme.textTheme.titleMedium,
            ),
            Obx(
              () => Text(
                "\$${controller.budgetRange.value.start.toInt()} - \$${controller.budgetRange.value.end.toInt()} USD",
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(
          () => FormBuilderRangeSlider(
            displayValues: DisplayValues.none,
            name: 'budgetRange',
            min: 1000,
            max: 5000,
            initialValue: controller.budgetRange.value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            labels: RangeLabels(
              '\$${controller.budgetRange.value.start.toInt()}',
              '\$${controller.budgetRange.value.end.toInt()}',
            ),
            onChanged: (values) {
              if (values != null) {
                controller.updateBudgetRange(values);
              }
            },
          ),
        ),
      ],
    );
  }
}

class _ServiceSelectionGrid extends StatelessWidget {
  final FormController controller;
  const _ServiceSelectionGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What do you need help with?* (Custom Options)",
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Obx(() => GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: controller.serviceOptionsConfig.map((config) {
                return ServiceOption(
                  title: config.title,
                  icon: config.icon,
                  isSelected:
                      controller.selectedServices.contains(config.value),
                  onTap: () => controller.toggleService(config.value),
                );
              }).toList(),
            )),
      ],
    );
  }
}

class _ToolSelectionGroup extends StatelessWidget {
  final FormController controller;
  const _ToolSelectionGroup({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Preferred Technologies/Tools* (CheckboxGroup)",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        FormBuilderCheckboxGroup<String>(
          name: 'tools',
          initialValue: controller.selectedTools.value,
          options: const [
            FormBuilderFieldOption(value: 'flutter', child: Text('Flutter')),
            FormBuilderFieldOption(value: 'react', child: Text('ReactJS')),
            FormBuilderFieldOption(value: 'vue', child: Text('VueJS')),
            FormBuilderFieldOption(value: 'angular', child: Text('Angular')),
            FormBuilderFieldOption(value: 'nodejs', child: Text('Node.js')),
            FormBuilderFieldOption(
                value: 'python', child: Text('Python/Django')),
          ],
          validator: FormBuilderValidators.required(
              errorText: 'Please select at least one tool'),
          onChanged: (values) {
            controller.selectedTools.value = values ?? [];
            controller.validateSecondForm();
          },
          separator: const SizedBox(height: 8),
          controlAffinity: ControlAffinity.leading,
        ),
      ],
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final FormController controller;
  final GlobalKey<FormBuilderState> formKey;

  const _BottomNavigation({required this.controller, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.disabledColor.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Step 2 of 2",
              style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Go back'),
            ),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isSecondFormValid.value
                    ? () {
                        if (formKey.currentState?.saveAndValidate() ?? false) {
                          controller.submitForm();
                        } else {
                          debugPrint("Validation failed on submit");
                        }
                      }
                    : null,
                child: const Text("Let's create!"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
