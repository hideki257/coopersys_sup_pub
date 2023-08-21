import 'package:flutter/material.dart';

class MeuCheckBox extends StatelessWidget {
  final bool? value;
  final String labelText;
  final ValueChanged<bool?>? onChanged;
  final bool isReadOnly;

  const MeuCheckBox({
    super.key,
    required this.labelText,
    this.value,
    this.onChanged,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    bool? value = this.value;

    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: isReadOnly ? null : onChanged,
          fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey.withOpacity(.32);
            }
            return Colors.grey;
          }),
        ),
        Text(labelText),
      ],
    );
  }
}
