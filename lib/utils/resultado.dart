class Resultado {
  final bool validado;
  final bool erro;
  final String mensagem;
  final String id;

  bool get ok => validado && !erro;

  Resultado({
    this.validado = true,
    this.erro = false,
    this.mensagem = '',
    this.id = '',
  });
}
