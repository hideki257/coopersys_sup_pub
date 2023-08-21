import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sup/models/cooper_user.dart';

import '../data/cooper_user_data.dart';
import '../data/usuario_data.dart';
import '../models/crud.dart';
import '../models/usuario.dart';
import '../utils/minha_excecao.dart';

class CooperUserCrudException extends MinhaExcecao {
  CooperUserCrudException(super.message);
}

class CooperUserCrudCont extends ChangeNotifier {
  final Ref ref;
  final CooperUserCrudKey cooperUserCrudKey;
  late CooperUser cooperUser;
  final List<Usuario> usuarios = [];
  bool isLoading = true;

  CooperUserCrudCont({required this.ref, required this.cooperUserCrudKey}) {
    refresh();
  }

  refresh() async {
    UsuarioData usuarioData = ref.read(usuarioDataProvider);
    usuarios = await usuarioData.ListaUsuarios();

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
  }
}
