DateTime primeiroDiaDoMes(DateTime? dtRef) {
  if (dtRef == null) {
    DateTime hoje = DateTime.now();
    return DateTime(hoje.year, hoje.month, 1);
  } else {
    return DateTime(dtRef.year, dtRef.month, 1);
  }
}

DateTime dataAtualSemHoras() {
  return dataSemHoras(DateTime.now());
}

DateTime dataSemHoras(DateTime data) {
  return DateTime(data.year, data.month, data.day);
}
