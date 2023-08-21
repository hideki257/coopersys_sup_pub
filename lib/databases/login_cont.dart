import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/usuario_data.dart';
import '../services/auth_service.dart';
import '../utils/resultado.dart';
import '../utils/validador_utils.dart';
import '../utils/formatacao_utils.dart';

final loginContProvider =
    ChangeNotifierProvider<LoginCont>((ref) => LoginCont(ref: ref));

class LoginCont extends ChangeNotifier {
  final Ref ref;
  LoginCont({required this.ref});

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLogin = true;

  final inputLogEmail = TextEditingController();
  final inputLogSenha = TextEditingController();

  final inputCadEmail = TextEditingController();
  final inputCadSenha = TextEditingController();
  final inputCadConfSen = TextEditingController();
  final inputCadNome = TextEditingController();
  DateTime? inputCadDataNasc;
  final outputCadDataNasc = TextEditingController();

  refresh() {
    isLogin = true;
    inputLogEmail.clear();
    inputLogSenha.clear();
    inputCadEmail.clear();
    inputCadSenha.clear();
    inputCadConfSen.clear();
    inputCadNome.clear();
    inputCadDataNasc = null;
    outputCadDataNasc.clear();
    notifyListeners();
  }

  toggleLogCad() {
    isLogin = !isLogin;
    if (isLogin) {
      inputLogEmail.text = inputCadEmail.text;
      inputCadEmail.clear();
    } else {
      inputCadEmail.text = inputLogEmail.text;
      inputLogEmail.clear();
    }
    inputLogSenha.clear();
    inputCadSenha.clear();
    inputCadConfSen.clear();
    inputCadNome.clear();
    inputCadDataNasc = null;
    outputCadDataNasc.clear();
    notifyListeners();
  }

  String? validarEmail(String? value) {
    return validarCampo(
        campo: 'Email', valor: value, regrasDeValidacao: [regraValidarVazio]);
  }

  String? validarSenha(String? value) {
    return validarCampo(
        campo: 'Senha',
        valor: value,
        regrasDeValidacao: [regraValidarVazio, regraValidarMaiorQue5]);
  }

  String? validarNome(String? value) {
    return validarCampo(
        campo: 'Nome', valor: value, regrasDeValidacao: [regraValidarVazio]);
  }

  String? validarCadSenha(String? value) {
    String? resultado = validarCampo(
        campo: 'Senha',
        valor: value,
        regrasDeValidacao: [regraValidarVazio, regraValidarMaiorQue5]);
    if (resultado != null) {
      return resultado;
    }
    if (inputCadConfSen.text != '' && inputCadConfSen.text != value) {
      return 'Confirmação de senha diferente da senha proposta!';
    }
    return null;
  }

  String? validarCadConfSen(String? value) {
    String? resultado = validarCampo(
        campo: 'Confirmação de senha',
        valor: value,
        regrasDeValidacao: [regraValidarVazio, regraValidarMaiorQue5]);
    if (resultado != null) {
      return resultado;
    }
    if (inputCadSenha.text != '' &&
        value != '' &&
        inputCadSenha.text != value) {
      return 'Confirmação de senha diferente da senha proposta!';
    }
    return null;
  }

  setDataNascimento(DateTime? value) {
    inputCadDataNasc = value;

    if (value != null) {
      outputCadDataNasc.text = value.toStrDdMmYyyy();
    } else {
      outputCadDataNasc.clear();
    }
    notifyListeners();
  }

  Future<Resultado> entrar() async {
    AuthService authService = ref.read(authServiceProvider);
    if (formKey.currentState!.validate()) {
      try {
        await authService.entrarComEmailESenha(
            inputLogEmail.text, inputLogSenha.text);
      } on Exception catch (e) {
        return Resultado(erro: true, mensagem: e.toString());
      }
      refresh();
      return Resultado();
    } else {
      return Resultado(validado: false);
    }
  }

  Future<Resultado> cadastrar() async {
    AuthService authService = ref.read(authServiceProvider);
    UsuarioData usuarioData = ref.read(usuarioDataProvider);
    if (formKey.currentState!.validate()) {
      try {
        await authService.criarComEmailESenha(
            inputCadEmail.text, inputCadSenha.text);
        await usuarioData.criarUsuario(
          userId: authService.user!.uid,
          email: inputCadEmail.text,
          nome: inputCadNome.text,
          dataNascimento: inputCadDataNasc,
        );
      } on Exception catch (e) {
        return Resultado(
          erro: true,
          mensagem: e.toString(),
        );
      }
      refresh();
      return Resultado();
    } else {
      return Resultado(validado: false);
    }
  }
}
