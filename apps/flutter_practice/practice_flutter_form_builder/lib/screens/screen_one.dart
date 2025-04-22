import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:practice_flutter_form_builder/screens/screen_two.dart';

import '../controllers/form_controller.dart';
import '../widgets/common_form_text_field.dart';

class ScreenOne extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final FormController formController = Get.find<FormController>();

  ScreenOne({super.key});

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
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.handshake_outlined,
                      color: theme.colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Let's work together",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "We're a full-service agency dedicated to helping you go from MVP to industry leader. Let our team bring your goals to life.",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CommonFormTextField(
                          name: 'firstName',
                          label: 'First name',
                          isRequired: true,
                          controller: formController.firstNameController,
                          focusNode: formController.firstNameFocusNode,
                          nextFocusNode: formController.lastNameFocusNode,
                          validator: FormBuilderValidators.required(
                            errorText: 'First name is required',
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: CommonFormTextField(
                          name: 'lastName',
                          label: 'Last name',
                          isRequired: true,
                          controller: formController.lastNameController,
                          focusNode: formController.lastNameFocusNode,
                          nextFocusNode: formController.emailFocusNode,
                          validator: FormBuilderValidators.required(
                            errorText: 'Last name is required',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  CommonFormTextField(
                    name: 'email',
                    label: 'Email',
                    isRequired: true,
                    controller: formController.emailController,
                    focusNode: formController.emailFocusNode,
                    nextFocusNode: formController.websiteFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Email is required'),
                      FormBuilderValidators.email(
                          errorText: 'Please enter a valid email'),
                    ]),
                    hintText: 'Email address',
                  ),
                  SizedBox(height: 24),
                  CommonFormTextField(
                    name: 'website',
                    label: 'Website',
                    controller: formController.websiteController,
                    focusNode: formController.websiteFocusNode,
                    nextFocusNode: formController.phoneFocusNode,
                    keyboardType: TextInputType.url,
                    validator: FormBuilderValidators.url(
                      errorText: 'Please enter a valid URL',
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Phone number",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  IntlPhoneField(
                    focusNode: formController.phoneFocusNode,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: '(555) 000-0000',
                    ),
                    initialCountryCode: 'US',
                    onChanged: (phone) {
                      formController.updatePhoneNumber(phone.completeNumber);
                    },
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(
                          formController.helpDescriptionFocusNode);
                    },
                  ),
                  SizedBox(height: 24),
                  CommonFormTextField(
                    name: 'helpDescription',
                    label: 'How can we help?',
                    controller: formController.helpDescriptionController,
                    focusNode: formController.helpDescriptionFocusNode,
                    textInputAction: TextInputAction.done,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    hintText:
                        'A brief summary of what you need help with, expected timelines, preferred communication method, etc.',
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.outline,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Step 1 of 2",
                            style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7)),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: formController.isFirstFormValid.value
                                ? () {
                                    if (_formKey.currentState
                                            ?.saveAndValidate() ??
                                        false) {
                                      Get.to(() => ScreenTwo());
                                    } else {
                                      debugPrint("Form is invalid");
                                    }
                                  }
                                : null,
                            child: Text('Continue'),
                          ),
                        ),
                      ),
                    ],
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
