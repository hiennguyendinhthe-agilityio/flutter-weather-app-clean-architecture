import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomTextFormField extends StatelessWidget {
  final String name;
  final String? labelText;
  final bool isRequired;
  final String? helperText;
  final String? errorText;
  final String? initialValue;
  final TextInputType? keyboardType;
  final String? Function(dynamic)? customValidator;
  final bool obscureText;
  final Widget? suffixIcon;
  final int? maxLines;
  final ValueChanged<String?>? onChanged;
  final bool isEnabled;

  const CustomTextFormField({
    super.key,
    required this.name,
    this.labelText,
    this.isRequired = false,
    this.helperText,
    this.errorText,
    this.initialValue,
    this.keyboardType,
    this.customValidator,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines,
    this.onChanged,
    this.isEnabled = true,
  });

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
        FormBuilderTextField(
          onChanged: (value) {
            debugPrint('onChanged: $value');
          },
          maxLines: maxLines,
          key: key,
          name: name,
          initialValue: initialValue,
          decoration: InputDecoration(
            labelText: labelText,
            helperText: helperText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: suffixIcon,
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: FormBuilderValidators.compose([
            if (isRequired)
              FormBuilderValidators.required(
                  errorText: '$labelText is required'),
            if (customValidator != null) (value) => customValidator!(value),
          ]),
          enabled: isEnabled,
        ),
      ],
    );
  }
}
