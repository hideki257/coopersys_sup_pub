class MinhaExcecao implements Exception {
  final String message;
  final bool debugMode = true;

  MinhaExcecao(this.message);

  @override
  String toString() {
    return debugMode ? '($runtimeType): $message' : message;
  }
}
