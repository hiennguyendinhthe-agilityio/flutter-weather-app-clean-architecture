import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CommonFormTextField extends StatelessWidget {
  final String name;
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final bool isRequired;
  final int? maxLines;

  const CommonFormTextField({
    super.key,
    required this.name,
    required this.label,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.hintText,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.keyboardType,
    this.isRequired = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRequired ? "$label*" : label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        FormBuilderTextField(
          name: name,
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          decoration: InputDecoration(
            hintText: hintText ?? label,
          ),
        ),
      ],
    );
  }
}
