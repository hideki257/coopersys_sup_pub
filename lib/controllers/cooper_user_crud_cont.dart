import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/cooper_data.dart';
import '../data/cooper_user_data.dart';
import '../data/usuario_data.dart';
import '../models/cooper.dart';
import '../models/cooper_user.dart';
import '../models/crud.dart';
import '../models/usuario.dart';
import '../utils/minha_excecao.dart';
import '../utils/resultado.dart';
import '../utils/validador_utils.dart';

class CooperUserCrudException extends MinhaExcecao {
  CooperUserCrudException(super.message);
}

final cooperUserCrudContProvider =
    ChangeNotifierProvider.family<CooperUserCrudCont, CooperUserCrudKey>(
        (ref, cooperUserCrudKey) => CooperUserCrudCont(
              ref: ref,
              cooperUserCrudKey: cooperUserCrudKey,
            ));

class CooperUserCrudCont extends ChangeNotifier {
  final Ref ref;
  final CooperUserCrudKey cooperUserCrudKey;
  late CooperUser cooperUser;
  final formKey = GlobalKey<FormState>();
  final outputCooperNome = TextEditingController();
  final outputUserNome = TextEditingController();
  String? userIdSelected;
  Usuario? usuarioSelected;
  List<Usuario> usuarios = [];
  bool isLoading = true;

  CooperUserCrudCont({required this.ref, required this.cooperUserCrudKey}) {
    refresh();
  }

  refresh() async {
    CooperData cooperData = ref.read(cooperDataProvider);
    Cooper? cooper =
        await cooperData.getCooperById(cooperId: cooperUserCrudKey.cooperId!);
    outputCooperNome.text = cooper!.nome;

    if (cooperUserCrudKey.crud == Crud.create) {
      UsuarioData usuarioData = ref.read(usuarioDataProvider);
      usuarios = await usuarioData.listarUsuarios();

      CooperUserData cooperUserData = ref.read(cooperUserDataProvider);
      List<CooperUser> cooperUserList =
          await cooperUserData.listarCooperUser(cooperUserCrudKey.cooperId!);
      for (var cooperUser in cooperUserList) {
        usuarios
            .removeWhere((element) => (element.userId == cooperUser.userId));
      }
      userIdSelected = null;
      outputUserNome.clear();
    } else {
      CooperUserData cooperUserData = await ref.watch(cooperUserDataProvider);
      CooperUser? cooperUser = await cooperUserData.getCooperUserById(
        cooperId: cooperUserCrudKey.cooperId!,
        userId: cooperUserCrudKey.userId!,
      );
      if (cooperUser != null) {
        this.cooperUser = cooperUser;
      } else {
        throw CooperUserCrudException('Usuário não associado à Cooperativa!');
      }

      outputUserNome.text = this.cooperUser.userNome;
      userIdSelected = this.cooperUser.userId;
    }
    isLoading = false;
    notifyListeners();
  }

  setUsuario(Usuario? usuario) {
    if (usuario == null) {
      userIdSelected = null;
      usuarioSelected = null;
    } else {
      userIdSelected = usuario.userId;
      usuarioSelected = usuario;
    }
  }

  String? validarUsuario(Usuario? value) {
    return validarNULL(
      campo: 'Usuário',
      valor: value,
    );
  }

  Future<Resultado> associar() async {
    Resultado result = Resultado();
    if (formKey.currentState!.validate()) {
      CooperUserData cooperUserData = ref.read(cooperUserDataProvider);
      result = await cooperUserData.insertCooperUser(
        cooperId: cooperUserCrudKey.cooperId!,
        user: usuarioSelected!,
      );
    } else {
      result = Resultado(
        validado: false,
      );
    }
    return result;
  }

  Future<Resultado> desassociar() async {
    Resultado result = Resultado();
    if (formKey.currentState!.validate()) {
      CooperUserData cooperUserData = ref.read(cooperUserDataProvider);
      result = await cooperUserData.deleteCooperUser(
        cooperId: cooperUserCrudKey.cooperId!,
        userId: cooperUserCrudKey.userId!,
      );
    } else {
      result = Resultado(
        validado: false,
      );
    }
    return result;
  }
}
