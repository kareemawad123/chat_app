import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final bool obscureText;

  const TextFieldWidget({
    Key? key,
    required this.controller,
    this.validator,
    this.obscureText = false, required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      decoration: inputDecoration(labelText),
      validator: validator,
      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    );
  }
}

InputDecoration inputDecoration(String labelText) => InputDecoration(
  labelText: labelText,
      labelStyle: const TextStyle(color: Colors.black),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(color: Colors.black),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(color: Colors.black),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(color: Colors.black),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(color: Colors.black),
  ),
    );
