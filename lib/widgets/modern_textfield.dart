import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;

  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool? obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final int maxLines;
  final Color? fillColor;
  final Color? labelColor;
  final Color? iconColor;
  final Color? textColor;
  const ModernTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLength,
    this.obscureText,
    this.readOnly = false,
    this.onTap,
    this.onChanged, // ✅ added
    this.suffix,
    this.maxLines = 1,
    this.fillColor,
    this.labelColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool hide = obscureText ?? false;
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged, // ✅ added
      maxLines: hide ? 1 : maxLines,
      obscureText: hide,
      style: textColor != null
          ? theme.textTheme.bodyMedium?.copyWith(color: textColor)
          : theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: iconColor ?? theme.iconTheme.color)
            : null,
        suffixIcon: suffix,
        filled: true,
        fillColor: fillColor ?? theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.4),
        ),
        labelStyle: labelColor != null
            ? theme.textTheme.bodyMedium?.copyWith(color: labelColor)
            : theme.textTheme.bodyMedium,
        hintStyle: theme.textTheme.bodySmall,
      ),
    );
  }
}
