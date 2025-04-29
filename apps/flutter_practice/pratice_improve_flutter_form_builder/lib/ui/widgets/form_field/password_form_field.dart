import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:pratice_improve_flutter_form_builder/ui/widgets/form_field/text_form_field.dart';

import '../../../core/abstractions/form_field.dart';

class PasswordFormField extends AbstractTextFormField {
  final String? confirmPasswordName;
  final String? confirmPasswordErrorText;

  const PasswordFormField({
    required super.name,
    super.labelText = 'Password',
    super.isRequired = true,
    super.helperText,
    super.errorText = 'Password is required',
    super.initialValue,
    this.confirmPasswordName,
    this.confirmPasswordErrorText = 'Passwords do not match',
  }) : super(
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
        );

  @override
  String? customValidator(dynamic value) {
    if (value != null && value.toString().isNotEmpty) {
      if (value.toString().length < 6) {
        return 'Password must be at least 6 characters long';
      }
    }

    if (confirmPasswordName != null &&
        Get.isRegistered<FormBuilderState>() &&
        FormBuilder.of(Get.context!)?.fields[confirmPasswordName]?.value !=
            null &&
        value !=
            FormBuilder.of(Get.context!)?.fields[confirmPasswordName]?.value) {}

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final RxBool obscureText = true.obs;

    return Obx(() => CustomTextFormField(
          name: name,
          labelText: labelText,
          isRequired: isRequired,
          helperText: helperText,
          errorText: errorText,
          initialValue: initialValue,
          keyboardType: keyboardType,
          obscureText: obscureText.value,
          maxLines: 1,
        ));
  }
}
