class UserCooper {
  final String cooperId;
  final String userId;
  final String cooperNome;

  UserCooper(
      {required this.cooperId, required this.userId, required this.cooperNome});

  Map<String, dynamic> toMap() {
    return {
      'cooperId': cooperId,
      'userId': userId,
      'cooperNome': cooperNome,
    };
  }

  UserCooper.fromMap(Map<String, dynamic> map)
      : cooperId = map['cooperId'],
        userId = map['userId'],
        cooperNome = map['cooperNome'];
}
