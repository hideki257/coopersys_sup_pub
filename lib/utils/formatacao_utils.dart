import 'package:intl/intl.dart';

extension FormatacaoUtilsDouble on double {
  String toStrForm2Dig() {
    return NumberFormat('#,##0.00', 'pt_BR').format(this);
    //return NumberFormat.decimalPattern('pt_BR').format(this);
  }

  String toStrFormNDig() {
    return NumberFormat('#,###.#', 'pt_BR').format(this);
    //return NumberFormat.decimalPattern('pt_BR').format(this);
  }
}

extension FormatacaoUtilsString on String {
  double? fromStrFormatado() {
    double result = 0;
    try {
      result = NumberFormat.decimalPattern('pt_BR').parse(this) as double;
    } on Exception catch (_) {
      return null;
    }
    return result;
  }

  DateTime fromStrDdmmyyy() {
    return DateFormat('dd/mm/yyy').parse(this);
  }
}

extension FromatacaoUtilsDateTime on DateTime {
  String toStrDdMmYyyy() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String toStrDdMm() {
    return DateFormat('dd/MM').format(this);
  }
}
