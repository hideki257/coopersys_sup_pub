import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/usuario.dart';
import 'path_ref.dart';

class UserCooperData {
  List<String> cooperIds = [];

  getCooperIds(
      FirebaseFirestore db, Transaction transaction, Usuario user) async {
    cooperIds = [];
    PathRef.colRefUserCoopers(db, user.userId).get().then((value) async {
      for (var doc in value.docs) {
        await transaction
            .get(PathRef.docRefUserCooper(db, user.userId, doc.id))
            .then((value) async {
          if (value.exists) {
            cooperIds.add(doc.id);
          }
        });
      }
    });
  }

  updateUserData(
      FirebaseFirestore db, Transaction transaction, Usuario user) async {
    for (var cooperId in cooperIds) {
      transaction.update(PathRef.docRefCooperUser(db, cooperId, user.userId),
          user.toMapCooperUser(cooperId));
    }
  }

  deleteUserData(
      FirebaseFirestore db, Transaction transaction, Usuario user) async {
    for (var cooperId in cooperIds) {
      transaction.delete(PathRef.docRefCooperUser(db, cooperId, user.userId));
    }
  }
}
