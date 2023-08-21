import 'package:flutter/material.dart';

Color corBackgroundReadOnly = Colors.grey.shade200;
const String titlePage = "CooperSys - Super";

Widget boolInativoToIcon(bool inativo) {
  return Icon(inativo ? Icons.do_disturb : Icons.check);
}

Widget boolInativoToIconCol(bool inativo) {
  return Icon(
    inativo ? Icons.do_disturb : Icons.check,
    color: boolInativoToColor(inativo),
  );
}

Color? boolInativoToColor(bool inativo) {
  return inativo ? Colors.grey.shade500 : Colors.green.shade500;
}

Widget boolFavoritoToIcon(bool favorito) {
  return Icon(favorito ? Icons.favorite : Icons.favorite_outline);
}

Color? boolFavoritoToColor(bool favorito) {
  return favorito ? Colors.red.shade500 : Colors.grey.shade500;
}

bool isWidthMobile(double maxWidth) {
  return maxWidth < 930;
}

bool isContextMobile(BuildContext context) {
  return isWidthMobile(MediaQuery.of(context).size.width);
}

bool isPortrait(BuildContext context) {
  return MediaQuery.of(context).size.width < MediaQuery.of(context).size.height;
}
