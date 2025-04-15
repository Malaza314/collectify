import 'package:collectify/Widgets/themedata.dart';
import 'package:collectify/Widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ObscuringTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String labelText;
  final bool? obscureText;
  final VoidCallback? toggleObscureText;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String value)? onChanged;

  const ObscuringTextField({
    super.key, 
    required this.textEditingController, 
    required this.labelText, 
    this.obscureText, 
    this.toggleObscureText, 
    required this.textInputType, 
    this.inputFormatters,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Container(
        decoration: BoxDecoration(
          color: neumorphic_light,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: blue,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: textEditingController, 
            keyboardType: textInputType,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            style: contentTextStyle(),
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              suffixIcon: obscureText != null 
                ? IconButton(
                    icon: obscureText!
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                    onPressed: toggleObscureText,
                    color: blue,
                  ) 
                : null, 
              labelText: labelText,
              labelStyle: contentTextStyle(
                fontColor: light_fonts_grey,
                fontSize: h4
              ), 
              fillColor: neumorphic_light, 
              filled: true
            ),
            obscureText: obscureText != null ? !obscureText! : false,
          ),
        ),
      ),
    );
  }
}