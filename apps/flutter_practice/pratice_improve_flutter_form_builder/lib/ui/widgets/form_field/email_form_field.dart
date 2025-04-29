import 'package:flutter/material.dart';
import 'package:pratice_improve_flutter_form_builder/ui/widgets/form_field/text_form_field.dart';

class EmailFormField extends StatelessWidget {
  final String name;
  final String labelText;
  final bool isRequired;
  final String? helperText;
  final String errorText;
  final String? initialValue;
  final TextInputType keyboardType = TextInputType.emailAddress;

  const EmailFormField({
    super.key,
    required this.name,
    this.labelText = 'Email address',
    this.isRequired = true,
    this.helperText,
    this.errorText = 'Please enter a valid email address',
    this.initialValue,
  });

  String? _customEmailValidator(dynamic value) {
    if (value != null && value.toString().isNotEmpty) {
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
      key: key,
      name: name,
      labelText: labelText,
      isRequired: isRequired,
      helperText: helperText,
      initialValue: initialValue,
      keyboardType: keyboardType,
      customValidator: _customEmailValidator,
    );
  }
}
