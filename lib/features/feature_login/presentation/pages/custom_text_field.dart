import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscurePassword : false,
      keyboardType: widget.keyboardType,
      validator: (v) {
        if (v == null || v.isEmpty) {
          return 'Please enter ${widget.hint}';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
      ),
      style: TextStyle(color: isDark ? Colors.white70 : Colors.black),
    );
  }
}
