import 'package:flutter/material.dart';

import 'App_textfield.dart';

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    required this.controller,
    this.hintText = "Enter your password",
    this.labelText,
    this.validator,
    this.onChanged,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController controller;
  final String hintText;
  final String? labelText;

  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;

  @override
  State<AppPasswordField> createState() => _AppPasswordField();
}
class _AppPasswordField extends State<AppPasswordField>{
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      hintText: widget.hintText,
      labelText: widget.labelText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,

      prefixIcon: const Icon(Icons.lock_outline),

      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
      ),
    );
  }
}