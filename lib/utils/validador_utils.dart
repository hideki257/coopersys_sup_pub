String? regraValidarVazio(
  String campo,
  String? valor,
) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Preencha "$campo"!';
  }
  return null;
}

String? regraValidarMaiorQue5(
  String campo,
  String? valor,
) {
  if (valor == null || valor.trim().length <= 5) {
    return '"$campo" deve ter mais do que 5 caracteres!';
  }
  return null;
}

String? regraValidarDec2Dig(String campo, String? valor) {
  if (valor != null && valor.isNotEmpty) {
    RegExp regexp = RegExp(r'^\d{1,3}(\.?\d{3})*(,\d{1,2})?$');
    if (!regexp.hasMatch(valor)) {
      return '"$campo" é inválido!';
    }
  }
  return null;
}

String? regraValidarDecNDig(String campo, String? valor) {
  if (valor != null && valor.isNotEmpty) {
    RegExp regexp = RegExp(r'^\d{1,3}(\.?\d{3})*(,\d+)?$');
    if (!regexp.hasMatch(valor)) {
      return '"$campo" é inválido!';
    }
  }
  return null;
}

String? regraValidarDec2DigSinal(String campo, String? valor) {
  if (valor != null && valor.isNotEmpty) {
    RegExp regexp = RegExp(r'^-?\d{1,3}(\.?\d{3})*(,\d{1,2})?$');
    if (!regexp.hasMatch(valor)) {
      return '"$campo" é inválido!';
    }
  }
  return null;
}

String? regraValidarDifZero(String campo, String? valor) {
  if (valor != null && valor.isNotEmpty) {
    RegExp regexp = RegExp(r'^-?0{1,3}(\.?0{3})*(,0+)?$');
    if (regexp.hasMatch(valor)) {
      return '"$campo" não pode ser zero!';
    }
  }
  return null;
}

String? regraValidarNumMaiorZero(String campo, String? valor) {
  if (valor != null && valor.isNotEmpty) {
    RegExp regexp = RegExp(r'^\d{2,}|[1-9]$');
    if (!regexp.hasMatch(valor)) {
      return '"$campo" não pode ser zero!';
    }
  }
  return null;
}

String? validarCampo(
    {required String campo,
    String? valor,
    required List<String? Function(String campo, String? valor)>
        regrasDeValidacao}) {
  String? resultado;
  for (var regraDeValidacao in regrasDeValidacao) {
    resultado = regraDeValidacao(campo, valor);
    if (resultado != null) {
      break;
    }
  }
  return resultado;
}

String? validarNULL({
  required String campo,
  dynamic valor,
}) {
  if (valor == null) {
    return 'Preencha "$campo"!';
  }
  return null;
}
