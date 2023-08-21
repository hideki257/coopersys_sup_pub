import 'package:flutter/material.dart';

import '../utils/const_utils.dart';

class MeuDropdown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final String labelText;
  final T? value;
  final bool isReadOnly;

  const MeuDropdown({
    super.key,
    required this.labelText,
    required this.items,
    this.onChanged,
    this.validator,
    this.value,
    this.isReadOnly = false,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<T>(
        items: items,
        onChanged: isReadOnly ? null : onChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          filled: isReadOnly,
          fillColor: isReadOnly ? corBackgroundReadOnly : null,
          iconColor: isReadOnly ? corBackgroundReadOnly : null,
          hoverColor: isReadOnly ? corBackgroundReadOnly : null,
          focusColor: isReadOnly ? corBackgroundReadOnly : null,
        ),
        value: value,
      ),
    );
  }
}
