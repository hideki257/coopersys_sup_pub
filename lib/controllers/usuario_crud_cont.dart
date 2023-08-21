import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/usuario_data.dart';
import '../models/crud.dart';
import '../models/usuario.dart';
import '../utils/formatacao_utils.dart';
import '../utils/resultado.dart';
import '../utils/validador_utils.dart';

final usuarioCrudContProvider =
    ChangeNotifierProvider.family<UsuarioCrudCont, UsuarioCrudKey>(
  (ref, usuarioCrudKey) =>
      UsuarioCrudCont(ref: ref, usuarioCrudKey: usuarioCrudKey),
);

class UsuarioCrudCont extends ChangeNotifier {
  final Ref ref;
  final UsuarioCrudKey usuarioCrudKey;
  UsuarioCrudCont({required this.ref, required this.usuarioCrudKey}) {
    refresh();
  }

  final formKey = GlobalKey<FormState>();
  final inputEmail = TextEditingController();
  final inputNome = TextEditingController();
  DateTime? inputDataNasc;
  final outputDataNasc = TextEditingController();

  refresh() async {
    if (usuarioCrudKey.crud.isNew) {
      inputEmail.clear();
      inputNome.clear();
      inputDataNasc = null;
      outputDataNasc.clear();
    } else {
      UsuarioData usuarioData = ref.read(usuarioDataProvider);
      Usuario usuario =
          await usuarioData.getUsuarioById(userId: usuarioCrudKey.userId);
      inputEmail.text = usuario.email ?? '';
      inputNome.text = usuario.nome ?? '';
      inputDataNasc = usuario.dataNascimento;
      outputDataNasc.text = inputDataNasc?.toStrDdMmYyyy() ?? '';
    }
    notifyListeners();
  }

  String? validarNome(String? value) {
    return validarCampo(
      campo: 'Nome',
      valor: value,
      regrasDeValidacao: [regraValidarVazio],
    );
  }

  setDataNasc(DateTime? value) {
    inputDataNasc = value;
    outputDataNasc.text = value?.toStrDdMmYyyy() ?? '';
    notifyListeners();
  }

  Future<Resultado> alterarUsuario() async {
    UsuarioData usuarioData = ref.read(usuarioDataProvider);
    if (formKey.currentState!.validate()) {
      return await usuarioData.alterarUsuario(
        usuario: Usuario(
          userId: usuarioCrudKey.userId,
          email: inputEmail.text,
          nome: inputNome.text.trim().isNotEmpty ? inputNome.text.trim() : null,
          dataNascimento: inputDataNasc,
        ),
      );
    } else {
      return Resultado(validado: false);
    }
  }
}
