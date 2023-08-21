import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../databases/db_firestore.dart';
import '../models/cooper.dart';
import '../models/cooper_user.dart';
import '../models/usuario.dart';
import '../utils/resultado.dart';
import 'path_ref.dart';

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
    PathRef.docRefCooperUser(db, cooperId, user.userId)
        .set(user.toMap())
        .then((value) async {
      result = Resultado(
        id: user.userId,
        mensagem: 'Usuario associado a cooperativa com sucesso!',
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
    PathRef.docRefCooperUser(db, cooperId, userId).delete().then((value) async {
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
}
