import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../databases/db_firestore.dart';
import '../models/usuario.dart';
import '../utils/minha_excecao.dart';
import '../utils/resultado.dart';
import 'path_ref.dart';

class UsuarioDataExeption extends MinhaExcecao {
  UsuarioDataExeption(super.message);
}

final usuarioDataProvider =
    Provider.autoDispose<UsuarioData>((_) => UsuarioData());

class UsuarioData {
  /*
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamSnapUsuarioById(
      String userId) {
    FirebaseFirestore db = DBFirestore.get();
    return PathRef.strSnapRefUserById(db, userId);
  }
  */

  Future<Resultado> criarUsuario({
    required String userId,
    required String email,
    String? nome,
    DateTime? dataNascimento,
  }) async {
    Resultado? result;
    FirebaseFirestore db = await DBFirestore.get();
    await PathRef.docRefUsuarioById(db, userId)
        .set(Usuario(
                userId: userId,
                email: email,
                nome: nome,
                dataNascimento: dataNascimento)
            .toMap())
        .catchError((e) {
      result = Resultado(erro: true, mensagem: e.toString());
    });
    return result ?? Resultado();
  }

  Future<Resultado> alterarUsuario({required Usuario usuario}) async {
    Resultado? result;
    FirebaseFirestore db = await DBFirestore.get();
    await PathRef.docRefUsuarioById(db, usuario.userId)
        .update(usuario.toMapUpdate())
        .catchError((e) {
      result = Resultado(erro: true, mensagem: e.toString());
    });
    return result ?? Resultado();
  }

  Future<Resultado> apagarUsuario({required String userId}) async {
    Resultado? result;
    FirebaseFirestore db = await DBFirestore.get();
    await PathRef.docRefUsuarioById(db, userId).delete().catchError((e) {
      result = Resultado(erro: true, mensagem: e.toString());
    });
    return result ?? Resultado();
  }

  Future<Usuario> getUsuarioById({required String userId}) async {
    Usuario? result;
    String erro = '';
    FirebaseFirestore db = await DBFirestore.get();
    await PathRef.docRefUsuarioById(db, userId).get().then((value) {
      if (value.exists) {
        result = Usuario.fromMap(value.data()!);
      }
    }).catchError((e) {
      erro = e.toString();
    });
    if (result != null) {
      return result!;
    } else {
      throw UsuarioDataExeption(erro);
    }
  }

  Future<bool> existeUsuarioByEmail(String email) async {
    bool retorno = false;
    FirebaseFirestore db = await DBFirestore.get();
    await PathRef.colRefUsuarios(db)
        .where('email', isEqualTo: email)
        .count()
        .get()
        .then((value) {
      retorno = value.count > 0;
    }).catchError((_) {});
    return retorno;
  }
}
