import 'package:flutter/material.dart';

enum TipoSnackBar { erro, info, aviso }

extension TipoSnackBarExt on TipoSnackBar {
  Color? _getBackgroundColor() {
    switch (this) {
      case TipoSnackBar.erro:
        return Colors.redAccent.shade700;
      case TipoSnackBar.aviso:
        return Colors.orangeAccent.shade700;
      case TipoSnackBar.info:
        return Colors.blueAccent.shade700;
    }
  }

  FontWeight? _getFontWeight() {
    switch (this) {
      case TipoSnackBar.erro:
        return FontWeight.bold;
      case TipoSnackBar.aviso:
        return FontWeight.bold;
      case TipoSnackBar.info:
        return null;
    }
  }

  FontWeight? get fontWeight => _getFontWeight();

  Color? get backgroundColor => _getBackgroundColor();
}

showMeuSnackbar(BuildContext context, String mensagem,
    {TipoSnackBar? tipoSnackBar, bool showCloseIcon = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      mensagem,
      style: TextStyle(
        fontWeight: tipoSnackBar?.fontWeight,
      ),
    ),
    backgroundColor: tipoSnackBar?.backgroundColor,
    showCloseIcon: showCloseIcon,
  ));
}
