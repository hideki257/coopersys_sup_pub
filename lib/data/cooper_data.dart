import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../databases/db_firestore.dart';
import '../models/cooper.dart';
import '../utils/resultado.dart';
import 'path_ref.dart';

final cooperDataProvider = Provider<CooperData>((_) => CooperData());

class CooperData {
  Future<Resultado> criarCooper(
      {String? cooperId, required String nome, bool inativa = false}) async {
    Resultado result = Resultado();
    FirebaseFirestore db = DBFirestore.get();
    Cooper cooper = Cooper(cooperId: cooperId, nome: nome, inativa: inativa);
    await PathRef.docRefCooperById(db, cooper.cooperId)
        .set(cooper.toMap())
        .then((value) {
      result = Resultado(
        id: cooper.cooperId,
        mensagem: 'Cooperativa criada com sucesso!',
      );
    }).catchError((error) {
      result = Resultado(
        erro: true,
        mensagem: error.toString(),
      );
    });
    return result;
  }

  Future<Resultado> alterarCooper({required Cooper cooper}) async {
    Resultado result = Resultado();
    FirebaseFirestore db = DBFirestore.get();

    await db.runTransaction((transaction) async {
      transaction.update(
          PathRef.docRefCooperById(db, cooper.cooperId), cooper.toMap());
    }).then((value) async {
      result = Resultado(
        id: cooper.cooperId,
        mensagem: 'Cooperativa alterada com sucesso!',
      );
    }).catchError((error) async {
      result = Resultado(
        erro: true,
        mensagem: error.toString(),
      );
    });
    /*
    await PathRef.docRefCooperById(db, cooper.cooperId)
        .update(cooper.toMap())
        .then((value) {
      result = Resultado(
        id: cooper.cooperId,
        mensagem: 'Cooperativa alterada com sucesso!',
      );
    }).catchError((error) {
      result = Resultado(
        erro: true,
        mensagem: error.toString(),
      );
    });
    */
    return result;
  }

  Future<Resultado> apagarCooper({required String cooperId}) async {
    Resultado result = Resultado();
    FirebaseFirestore db = DBFirestore.get();
    await PathRef.docRefCooperById(db, cooperId).delete().then((value) {
      result = Resultado(
        id: cooperId,
        mensagem: 'Cooperativa apagada com sucesso!',
      );
    }).catchError((error) {
      result = Resultado(
        erro: true,
        mensagem: error.toString(),
      );
    });
    return result;
  }

  Future<List<Cooper>> listarTodas() async {
    List<Cooper> result = [];
    FirebaseFirestore db = DBFirestore.get();
    await PathRef.colRefCoopers(db).get().then((value) {
      for (var doc in value.docs) {
        result.add(Cooper.fromMap(doc.data()));
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('CooperData.listarTodas-${error.toString()}');
      }
    });
    return result;
  }

  Future<Cooper?> getCooperById({required String cooperId}) async {
    Cooper? result;
    FirebaseFirestore db = DBFirestore.get();
    await PathRef.docRefCooperById(db, cooperId).get().then((value) {
      if (value.exists) {
        result = Cooper.fromMap(value.data()!);
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('CooperativaData.cooperById-${error.toString()}');
      }
    });
    return result;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> strQrySnpCooperList() {
    FirebaseFirestore db = DBFirestore.get();
    return PathRef.strQSnapCooperList(db);
  }

  Future<Stream<Cooper>> strCooperById(String cooperId) async {
    FirebaseFirestore db = await DBFirestore.get();
    Stream stream = PathRef.strDocCooperById(db, cooperId);
    return stream.map<Cooper>((doc) => Cooper.fromMap(doc.data()));
  }
}
