import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../databases/db_firestore.dart';
import '../models/cooper.dart';
import '../models/cooper_user.dart';
import '../models/usuario.dart';
import '../utils/minha_excecao.dart';
import '../utils/resultado.dart';
import 'path_ref.dart';

class CooperUserDataException extends MinhaExcecao {
  CooperUserDataException(super.message);
}

final cooperUserDataProvider =
    Provider<CooperUserData>((_) => CooperUserData());

class CooperUserData {
  List<String> usuerIds = [];

  getUserIds(
      FirebaseFirestore db, Transaction transaction, Cooper cooper) async {
    usuerIds = [];
    PathRef.colRefCooperUsers(db, cooper.cooperId).get().then((value) async {
      for (var doc in value.docs) {
        await transaction
            .get(PathRef.docRefCooperUser(db, cooper.cooperId, doc.id))
            .then((value) async {
          if (value.exists) {
            usuerIds.add(doc.id);
          }
        });
      }
    });
  }

  Future<CooperUser?> getCooperUserById({
    required String cooperId,
    required String userId,
  }) async {
    CooperUser? result;
    FirebaseFirestore db = DBFirestore.get();
    await PathRef.docRefCooperUser(db, cooperId, userId).get().then((value) {
      if (value.exists) {
        result = CooperUser.fromMap(value.data()!);
      }
    }).catchError((error) {
      print('CooperUserData.cooperById-${error.toString()}');
    });
    return result;
  }

  Future<Resultado> insertCooperUser({
    required String cooperId,
    required Usuario user,
  }) async {
    Resultado result = Resultado();
    FirebaseFirestore db = await DBFirestore.get();
    // Get a new write batch
    //
    await db.runTransaction((transaction) async {
      Cooper? cooper;
      await transaction
          .get(PathRef.docRefCooperById(db, cooperId))
          .then((value) {
        if (value.exists) {
          cooper = Cooper.fromMap(value.data()!);
        }
      });
      if (cooper == null) {
        throw CooperUserDataException('');
      }

      transaction.set(PathRef.docRefCooperUser(db, cooperId, user.userId),
          user.toMapCooperUser(cooperId));

      transaction.set(PathRef.docRefUserCooper(db, user.userId, cooperId),
          cooper!.toMapUserCooper(user.userId));
    }).then((value) async {
      result = Resultado(
        id: user.userId,
        mensagem: 'Usuário associado a cooperativa com sucesso!',
      );
    }).catchError((error) async {
      result = Resultado(
        erro: true,
        mensagem: error.toString(),
      );
    });
    return result;
  }

  Future<Resultado> deleteCooperUser({
    required String cooperId,
    required String userId,
  }) async {
    Resultado result = Resultado();
    FirebaseFirestore db = await DBFirestore.get();
    final batch = db.batch();
    batch.delete(PathRef.docRefCooperUser(db, cooperId, userId));

    batch.delete(PathRef.docRefUserCooper(db, userId, cooperId));

    batch.commit().then((value) async {
      result = Resultado(
        id: userId,
        mensagem: 'Usuario desassociado da cooperativa com sucesso!',
      );
    }).catchError((error) async {
      result = Resultado(
        erro: true,
        mensagem: error.toString(),
      );
    });
    return result;
  }

  updateCooperData(
      FirebaseFirestore db, Transaction transaction, Cooper cooper) async {
    for (var userId in usuerIds) {
      transaction.update(PathRef.docRefUserCooper(db, userId, cooper.cooperId),
          cooper.toMapUserCooper(userId));
    }
  }

  deleteCooperData(
      FirebaseFirestore db, Transaction transaction, Cooper cooper) async {
    for (var userId in usuerIds) {
      transaction.delete(PathRef.docRefUserCooper(db, userId, cooper.cooperId));
    }
  }

  Stream<List<CooperUser>> strCooperUserList(String cooperId) {
    FirebaseFirestore db = DBFirestore.get();
    Stream stream = PathRef.strQrySnpCooperUsers(db, cooperId);
    return stream.map<List<CooperUser>>((qrySnps) => qrySnps.docs
        .map<CooperUser>((doc) => CooperUser.fromMap(doc.data()))
        .toList());
  }

  Future<List<CooperUser>> listarCooperUser(String cooperId) async {
    List<CooperUser> result = [];
    FirebaseFirestore db = await DBFirestore.get();
    await PathRef.colRefCooperUsers(db, cooperId).get().then((value) async {
      for (var doc in value.docs) {
        result.add(CooperUser.fromMap(doc.data()));
      }
    }).catchError((_) {
      result = [];
    });
    return result;
  }
}
