import 'package:flutter/material.dart';
import 'package:pratice_improve_flutter_form_builder/ui/widgets/form_field/text_form_field.dart';

import '../../../core/abstractions/form_field.dart';

class WebsiteFormField extends AbstractTextFormField {
  const WebsiteFormField({
    required super.name,
    super.labelText = 'Personal website',
    super.isRequired = false,
    super.helperText = 'Your home page, blog, or company site.',
    super.errorText = 'Please enter a valid URL',
    super.initialValue,
  }) : super(
          keyboardType: TextInputType.url,
        );

  @override
  String? customValidator(dynamic value) {
    if (value != null && value.toString().isNotEmpty) {
      // Simple URL validation regex
      final urlRegex = RegExp(
          r'^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$');
      if (!urlRegex.hasMatch(value.toString())) {
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
