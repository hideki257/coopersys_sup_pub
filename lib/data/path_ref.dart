import 'package:cloud_firestore/cloud_firestore.dart';

class PathRef {
  static DocumentReference<Map<String, dynamic>> docRefUsuarioById(
      FirebaseFirestore db, String userId) {
    return db.collection('usuarios').doc(userId);
  }

  static CollectionReference<Map<String, dynamic>> colRefUsuarios(
      FirebaseFirestore db) {
    return db.collection('usuarios');
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> strSnapRefUserById(
      FirebaseFirestore db, String userId) {
    return db.collection('usuarios').doc(userId).snapshots();
  }

  static DocumentReference<Map<String, dynamic>> docRefCooperById(
      FirebaseFirestore db, String cooperId) {
    return db.collection('cooperativas').doc(cooperId);
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> strDocCooperById(
      FirebaseFirestore db, String cooperId) {
    return db.collection('cooperativas').doc(cooperId).snapshots();
  }

  static CollectionReference<Map<String, dynamic>> colRefCoopers(
      FirebaseFirestore db) {
    return db.collection('cooperativas');
  }

  static CollectionReference<Map<String, dynamic>> colRefCooperUsers(
      FirebaseFirestore db, String cooperId) {
    return db.collection('cooperativas').doc(cooperId).collection('usuarios');
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> strQrySnpCooperUsers(
      FirebaseFirestore db, String cooperId) {
    return db
        .collection('cooperativas')
        .doc(cooperId)
        .collection('usuarios')
        .snapshots();
  }

  static DocumentReference<Map<String, dynamic>> docRefCooperUser(
      FirebaseFirestore db, String cooperId, String userId) {
    return db
        .collection('cooperativas')
        .doc(cooperId)
        .collection('usuarios')
        .doc(userId);
  }

  static CollectionReference<Map<String, dynamic>> colRefUserCoopers(
      FirebaseFirestore db, String userId) {
    return db.collection('usuarios').doc(userId).collection('cooperativas');
  }

  static DocumentReference<Map<String, dynamic>> docRefUserCooper(
      FirebaseFirestore db, String userId, String cooperId) {
    return db
        .collection('usuarios')
        .doc(userId)
        .collection('cooperativas')
        .doc(cooperId);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> strQSnapCooperList(
      FirebaseFirestore db) {
    return db.collection('cooperativas').snapshots();
  }
}
