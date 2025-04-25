import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../core/abstractions/form_field.dart';

class PhoneFormField extends AbstractFormField {
  final String initialCountryCode;

  const PhoneFormField({
    required super.name,
    super.labelText = 'Phone number',
    super.isRequired = true,
    super.helperText,
    super.errorText = 'Please enter a valid phone number',
    super.initialValue,
    this.initialCountryCode = 'ID',
  });

  @override
  String? customValidator(dynamic value) {
    if (value != null && value.toString().isNotEmpty) {
      final phoneRegex = RegExp(r'^\+?[0-9]{8,}$');
      if (!phoneRegex
          .hasMatch(value.toString().replaceAll(RegExp(r'\D'), ''))) {
        return errorText;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: labelText,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            children: isRequired
                ? [
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        FormBuilderField<String>(
          name: name,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<String> field) {
            return IntlPhoneField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.phone,
              initialCountryCode: initialCountryCode,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.5))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary)),
                errorBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).colorScheme.error)),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error, width: 2)),
                hintText: 'Enter your phone number',
                errorText: field.errorText,
              ),
              onChanged: (phone) {
                field.didChange(phone.completeNumber);
              },
            );
          },
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
