import 'package:flutter/material.dart';
import 'package:taskyy/shared/resources/color_manager.dart';
import 'package:taskyy/shared/resources/text_manager.dart';

class DefaultTextFormFeild extends StatelessWidget {
  DefaultTextFormFeild(
      {super.key,
      required this.controller,
      required this.valdation,
      this.title,
      this.suffixIcon,
      this.prefixxIcon,
      required this.readOnly,
      required this.label,
      this.labelStyle,
      this.style,
      this.onChanged,
      this.maxLines,
      this.keyboardType
      });

  String? title;
  final dynamic controller;
  final String valdation;
  final suffixIcon;
  final prefixxIcon;
  final bool readOnly;
  final String label;

  TextStyle? style;
  TextStyle? labelStyle;
  ValueChanged<String>? onChanged;
  int? maxLines;
  TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        title == null
            ? const SizedBox(
                height: 0,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title ?? '',
                    style:  AppText.w70014(),
                  ),
                ],
              ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          style: style,
          readOnly: readOnly,
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: prefixxIcon,
            labelText: label,
            labelStyle: labelStyle,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: ColorManager.black,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: ColorManager.black,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: ColorManager.black,
                width: 1,
              ),
            ),
            hintStyle: AppText.w40014(),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return valdation;
            }
            return null;
          },
        ),
      ],
    );
  }
}
