import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../data/country_data.dart';
import 'parts/custom_phone_input.dart';

class PhoneFormFieldWidget extends StatelessWidget {
  final String name;
  final String labelText;
  final bool isRequired;
  final String? helperText;
  final String? errorTextForIsRequired;
  final String? initialValue;
  final AutovalidateMode autovalidateMode;

  final String initialCountryCode;
  final List<CountryPhoneData> countries;

  const PhoneFormFieldWidget({
    super.key,
    required this.name,
    this.labelText = 'Phone number',
    this.isRequired = true,
    this.helperText,
    this.errorTextForIsRequired = 'Phone number is required',
    this.initialValue,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.initialCountryCode = 'VN',
    this.countries = kCountryData,
  });

  String? _validator(String? value) {
    if (isRequired && (value == null || value.isEmpty)) {
      return errorTextForIsRequired;
    }

    return _customPhoneValidator(value);
  }

  String? _customPhoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final String stringValue = value.toString();
    final phoneRegex = RegExp(r'^\+\d{1,3}\d+$');
    if (!phoneRegex.hasMatch(stringValue)) {
      return 'Please enter a valid phone number (VD: +84xxxxxx)';
    }

    CountryPhoneData? matchedCountry;
    String numberPart = '';
    List<CountryPhoneData> sortedCountries = List.from(countries);
    sortedCountries
        .sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));

    for (final country in sortedCountries) {
      if (stringValue.startsWith(country.dialCode)) {
        matchedCountry = country;
        numberPart = stringValue.substring(country.dialCode.length);
        break;
      }
    }

    if (matchedCountry != null) {
      if (numberPart.length < matchedCountry.minLength ||
          numberPart.length > matchedCountry.maxLength) {
        if (matchedCountry.minLength == matchedCountry.maxLength) {
          return 'Phone number ${matchedCountry.name} have to ${matchedCountry.maxLength} digits.';
        } else {
          return 'Phone number ${matchedCountry.name} have to ${matchedCountry.minLength} to ${matchedCountry.maxLength} digits.';
        }
      }
    } else {
      return 'ID number is not supported. Please select another country.';
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
          onChanged: (value) {
            debugPrint('onChanged: $value');
          },
          name: name,
          validator: _validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<String?> field) {
            final decoration = InputDecoration(
              errorText: field.errorText,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            );

            return CustomPhoneInputWithBottomSheet(
              initialValue: field.value,
              initialCountryCode: initialCountryCode,
              decoration: decoration,
              onChanged: (value) {
                field.didChange(value);
              },
              keyboardType: TextInputType.phone,
              countries: countries,
            );
          },
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12.0),
            child: Text(
              helperText!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ],
    );
  }
}
