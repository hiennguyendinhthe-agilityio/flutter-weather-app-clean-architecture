import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pratice_improve_flutter_form_builder/ui/widgets/form_field/phone_form_field.dart';
import 'package:pratice_improve_flutter_form_builder/ui/widgets/form_field/text_form_field.dart';

import '../../../../controllers/application_controller.dart';
import '../../../widgets/form_field/email_form_field.dart';
import '../../../widgets/form_field/website_form_field.dart';

class PersonalInfoScreen extends StatelessWidget {
  final ApplicationController controller;

  const PersonalInfoScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FormBuilder(
        onChanged: () {
          controller.updatePersonalInfoFormButtonState();
        },
        key: controller.personalInfoFormKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal information',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Let us get to know you a bit better by sharing your basic info.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '*Required fields',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextFormField(
                    name: 'fullName',
                    labelText: 'Full name',
                    isRequired: true,
                    initialValue: controller.application.fullName.value,
                    helperText:
                        "We're big on real names, so people know who's who.",
                  ),
                  const SizedBox(height: 24),
                  PhoneFormField(
                    name: 'phoneNumber',
                    isRequired: true,
                    initialValue: controller.application.phoneNumber.value,
                  ).build(context),
                  const SizedBox(height: 24),
                  EmailFormField(
                    name: 'emailAddress',
                    isRequired: true,
                    initialValue: controller.application.emailAddress.value,
                  ).build(context),
                ],
              ),
            ),
            Divider(
              height: 10,
              thickness: 8,
              color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WebsiteFormField(
                    name: 'personalWebsite',
                    isRequired: false,
                    initialValue: controller.application.personalWebsite.value,
                  ).build(context),
                  const SizedBox(height: 24),
                  CustomTextFormField(
                    name: 'portfolioUrl',
                    labelText: 'Portfolio URL',
                    isRequired: false,
                    initialValue: controller.application.portfolioUrl.value,
                    helperText: 'Only shared with potential employers.',
                    keyboardType: TextInputType.url,
                  ).build(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
