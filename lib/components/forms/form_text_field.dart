import 'package:flutter/material.dart';

import '../../classes/colors.dart';

class FormTextField {
  TextEditingController controller;
  IconData icon;
  bool obscureText;
  String hintText;

  FormTextField({
    required this.controller,
    required this.icon,
    required this.obscureText,
    required this.hintText
  });

  TextField get() {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.highlight),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.highlight, width: 2),
              borderRadius: BorderRadius.circular(20)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.highlight, width: 2),
              borderRadius: BorderRadius.circular(20)
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.highlight)
      ),
      obscureText: obscureText,
      cursorColor: AppColors.highlight,
      style: const TextStyle(color: AppColors.highlight),
    );
  }
}
