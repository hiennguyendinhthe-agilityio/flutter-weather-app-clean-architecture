import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Abstract base class for all form fields
abstract class AbstractFormField {
  /// The field name used in the form
  final String name;

  /// The label text displayed above the field
  final String labelText;

  /// Whether this field is required
  final bool isRequired;

  /// Helper text displayed below the field
  final String? helperText;

  /// Error message for invalid input
  final String? errorText;

  /// Initial value for the field
  final dynamic initialValue;

  final AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;

  const AbstractFormField({
    required this.name,
    required this.labelText,
    this.isRequired = false,
    this.helperText,
    this.errorText,
    this.initialValue,
  });

  /// Build the form field widget
  Widget build(BuildContext context);

  /// Validate the field value
  String? validator(dynamic value) {
    if (isRequired && (value == null || value.toString().isEmpty)) {
      return errorText ?? 'This field is required';
    }
    return customValidator(value);
  }

  /// Custom validation logic to be implemented by subclasses
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
}

/// Abstract class for text-based form fields
abstract class AbstractTextFormField extends AbstractFormField {
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  const AbstractTextFormField({
    required super.name,
    required super.labelText,
    super.isRequired,
    super.helperText,
    super.errorText,
    super.initialValue,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  });
}
