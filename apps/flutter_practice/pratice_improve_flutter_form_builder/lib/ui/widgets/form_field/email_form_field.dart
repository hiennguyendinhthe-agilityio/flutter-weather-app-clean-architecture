import 'package:flutter/material.dart';
import 'package:pratice_improve_flutter_form_builder/ui/widgets/form_field/text_form_field.dart';

import '../../../core/abstractions/form_field.dart';

class EmailFormField extends AbstractTextFormField {
  const EmailFormField({
    required super.name,
    super.labelText = 'Email address',
    super.isRequired = true,
    super.helperText,
    super.errorText = 'Please enter a valid email address',
    super.initialValue,
  }) : super(
          keyboardType: TextInputType.emailAddress,
        );

  @override
  String? customValidator(dynamic value) {
    if (value != null && value.toString().isNotEmpty) {
      // Simple email validation regex
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value.toString())) {
        return errorText;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      name: name,
      labelText: labelText,
      isRequired: isRequired,
      helperText: helperText,
      errorText: errorText,
      initialValue: initialValue,
      keyboardType: keyboardType,
    ).build(context);
  }
}
