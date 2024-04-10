import 'package:flutter/material.dart';
import 'package:music_player/core/constants/app_colors.dart';
import 'package:music_player/core/utils/extensions.dart';

class AnimatedTextField extends StatefulWidget {
  const AnimatedTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.onSaved,
    this.onChanged,
    this.keyboardType,
    this.isPassword = false,
    this.validator,
  });

  final String? hintText;
  final IconData? prefixIcon;
  final Function(String?)? onSaved;
  final Function(String?)? onChanged;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField> {
  final _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500), // Animation duration
      padding: EdgeInsets.symmetric(horizontal: _hasFocus ? 0 : 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_hasFocus ? 12 : 18),
        color: _hasFocus ? null : AppColor.primary,
      ),
      curve: Curves.easeInOut, // Animation curve
      child: TextFormField(
        focusNode: _focusNode,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword,
        validator: widget.validator,
        decoration: InputDecoration(
          hintText: widget.hintText,
          filled: true,
          fillColor: AppColor.textFieldColor,
          errorStyle: context.themeData.textTheme.labelSmall,
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  color: AppColor.primary,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: AppColor.primary,
              width: 1.5,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
      ),
    );
  }
}
