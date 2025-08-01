import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: validator,
      obscureText: obscureText,
    );
  }
}
