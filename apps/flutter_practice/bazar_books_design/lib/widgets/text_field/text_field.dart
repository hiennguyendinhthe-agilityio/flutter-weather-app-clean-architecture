import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/themes/typogaraphy.dart';
import 'package:bazar_books_design/widgets/texts/texts.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../constants.dart';

class BazUiTextField extends StatelessWidget {
  const BazUiTextField({
    this.focusNode,
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.decoration,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
  });

  /// The [FocusNode] that will be used to determine the focus of this text field.
  ///
  /// This is equivalent to [TextField.focusNode].
  final FocusNode? focusNode;

  /// The hint text to display inside the text field.
  final String? hintText;

  /// The label text to display above the text field.
  final String? labelText;

  final TextEditingController? controller;

  final InputDecoration? decoration;

  final bool obscureText;

  final Widget? suffixIcon;

  final String? Function(String?)? validator;

  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BazUiBodyText2(
          text: labelText ?? '',
        ),
        TextFormField(
          keyboardType: keyboardType,
          onSaved: (value) {},
          validator: validator ??
              MultiValidator(
                [
                  RequiredValidator(
                    errorText: Constants.requiredField,
                  ),
                  EmailValidator(
                    errorText: Constants.emailError,
                  ),
                ],
              ).call,
          obscureText: obscureText,
          controller: controller,
          style: BazUiTypographyFoundation.bodyMediumRegular.copyWith(
            color: context.colorScheme.onSecondaryContainer,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
