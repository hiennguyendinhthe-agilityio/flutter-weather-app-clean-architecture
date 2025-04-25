import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../controllers/application_controller.dart';
import '../widgets/file_upload_widget.dart';

class AdditionalInfoScreen extends StatelessWidget {
  final ApplicationController controller;

  const AdditionalInfoScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional information',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'In order to match you with the right opportunities we need some additional information first.',
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
            FormBuilder(
              onChanged: () {
                controller.updateAdditionalInfoFormButtonState();
              },
              key: controller.additionalInfoFormKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Cover letter',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                          children: [
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        name: 'coverLetter',
                        initialValue: controller.application.coverLetter.value,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          hintText: 'Sell yourself here...',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a cover letter';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(
                    height: 10,
                    thickness: 8,
                    color: Theme.of(context)
                        .colorScheme
                        .scrim
                        .withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 16),
                  FileUploadWidget(controller: controller),
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
