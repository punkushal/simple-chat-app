import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonLabelText,
    this.onPressed,
    required this.isLoading,
    this.color,
  });
  final String buttonLabelText;
  final void Function()? onPressed;
  final bool isLoading;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12),
        ),
      ),
      child: Text(buttonLabelText),
    );
  }
}
