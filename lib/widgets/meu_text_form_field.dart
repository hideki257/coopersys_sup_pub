import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../utils/const_utils.dart';

typedef StringFunction<String> = String? Function(String? value);
typedef CallbackFunction = void Function();
typedef SetDataNull = void Function(DateTime? value);
typedef SetDataNotNull = void Function(DateTime value);

class MeuTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? initialText;
  final bool isReadOnly;
  final StringFunction<String>? validator;
  final CallbackFunction? onTap;
  final bool obscureText;
  final bool isData;
  final bool isMonth;
  final List<TextInputFormatter>? inputFormatters;
  final bool showClearButton;
  final CallbackFunction? onClearButtonTap;
  final TextAlign textAlign;
  final int? maxLength;
  final int? errorMaxLines;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final int anosSomaDef;
  final bool retornaDataNull;
  final SetDataNull? onTapNullReturn;
  final SetDataNotNull? onTapNotNullReturn;
  final int? maxLines;
  final int? minLines;

  const MeuTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.initialText,
    this.isReadOnly = false,
    this.validator,
    this.onTap,
    this.obscureText = false,
    this.isData = false,
    this.isMonth = false,
    this.inputFormatters,
    this.showClearButton = false,
    this.onClearButtonTap,
    this.textAlign = TextAlign.start,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.errorMaxLines = 4,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.anosSomaDef = 50,
    this.retornaDataNull = false,
    this.onTapNullReturn,
    this.onTapNotNullReturn,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        initialValue: initialText,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          filled: isReadOnly,
          fillColor: isReadOnly ? corBackgroundReadOnly : null,
          iconColor: isReadOnly ? corBackgroundReadOnly : null,
          hoverColor: isReadOnly ? corBackgroundReadOnly : null,
          focusColor: isReadOnly ? corBackgroundReadOnly : null,
          suffixIcon: (!isReadOnly && showClearButton)
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClearButtonTap,
                )
              : null,
          errorMaxLines: errorMaxLines,
        ),
        textAlign: textAlign,
        readOnly: isReadOnly || isData || isMonth,
        validator: validator,
        onTap: isReadOnly
            ? null
            : onTap ??
                (isData
                    ? () async => await _onTapForData(context)
                    : (isMonth
                        ? () async => await _onTapForMonth(context)
                        : null)),
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
      ),
    );
  }

  _onTapForData(BuildContext context) async {
    DateTime hoje = DateTime.now();
    DateTime? data = await showDatePicker(
      context: context,
      initialDate: initialDate ?? hoje,
      firstDate: firstDate ?? DateTime(hoje.year - anosSomaDef),
      lastDate: lastDate ?? DateTime(hoje.year + anosSomaDef),
      locale: const Locale('pt', 'BR'),
    );
    if (onTapNullReturn != null) {
      onTapNullReturn!(data);
    } else if (onTapNotNullReturn != null) {
      if (data != null) {
        onTapNotNullReturn!(data);
      }
    }
  }

  _onTapForMonth(BuildContext context) async {
    DateTime hoje = initialDate ?? DateTime.now();
    hoje = DateTime(hoje.year, hoje.month, 1);

    DateTime? data = await showMonthYearPicker(
      context: context,
      initialDate: initialDate ?? hoje,
      firstDate: firstDate ?? DateTime(hoje.year - anosSomaDef),
      lastDate: lastDate ?? DateTime(hoje.year + anosSomaDef),
      locale: const Locale('pt', 'BR'),
    );
    if (onTapNullReturn != null) {
      onTapNullReturn!(data);
    } else if (onTapNotNullReturn != null) {
      if (data != null) {
        onTapNotNullReturn!(data);
      }
    }
  }
}
