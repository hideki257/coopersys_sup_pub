import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sup/models/crud.dart';

import '../data/cooper_data.dart';
import '../models/cooper.dart';
import '../utils/minha_excecao.dart';
import '../utils/resultado.dart';
import '../utils/validador_utils.dart';

class CooperCrudContException extends MinhaExcecao {
  CooperCrudContException(super.message);
}

final cooperCrudContProvider =
    ChangeNotifierProvider.family<CooperCrudCont, CooperCrudKey>(
        (ref, cooperCrudKey) =>
            CooperCrudCont(ref: ref, cooperCrudKey: cooperCrudKey));

class CooperCrudCont extends ChangeNotifier {
  final Ref ref;
  CooperCrudKey cooperCrudKey;
  final formKey = GlobalKey<FormState>();
  final inputNome = TextEditingController();
  bool inputInativa = false;
  bool isLoading = true;

  CooperCrudCont({required this.ref, required this.cooperCrudKey}) {
    refresh();
  }

  refresh() async {
    if (cooperCrudKey.crud.isNew) {
      inputNome.clear();
      inputInativa = false;
    } else {
      CooperData cooperData = ref.read(cooperDataProvider);
      Cooper? cooper =
          await cooperData.getCooperById(cooperId: cooperCrudKey.cooperId!);
      if (cooper == null) {
        throw CooperCrudContException(
            'Cooperativa "${cooperCrudKey.cooperId}" não encontrada!');
      }
      inputNome.text = cooper.nome;
      inputInativa = cooper.inativa;
    }
    isLoading = true;
    notifyListeners();
  }

  String? validarNome(String? value) {
    return validarCampo(
      campo: 'Nome',
      valor: value,
      regrasDeValidacao: [regraValidarVazio],
    );
  }

  setInativa(bool? value) {
    inputInativa = value ?? false;
    notifyListeners();
  }

  Future<Resultado> persistir() async {
    if (cooperCrudKey.crud.isAction) {
      CooperData cooperData = ref.read(cooperDataProvider);
      if (cooperCrudKey.crud == Crud.delete) {
        return cooperData.apagarCooper(cooperId: cooperCrudKey.cooperId!);
      } else {
        if (cooperCrudKey.crud == Crud.create) {
          return await cooperData.criarCooper(
            nome: inputNome.text,
            inativa: inputInativa,
          );
        } else {
          return await cooperData.alterarCooper(
            cooper: Cooper(
              cooperId: cooperCrudKey.cooperId,
              nome: inputNome.text,
              inativa: inputInativa,
            ),
          );
        }
      }
    } else {
      return Resultado(validado: false);
    }
  }
}
