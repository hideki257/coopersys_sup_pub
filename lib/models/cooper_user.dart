class CooperUser {
  final String cooperId;
  final String userId;
  final String userNome;

  CooperUser(
      {required this.cooperId, required this.userId, required this.userNome});

  Map<String, dynamic> toMap() {
    return {
      'cooperId': cooperId,
      'userId': userId,
      'userNome': userNome,
    };
  }

  CooperUser.fromMap(Map<String, dynamic> map)
      : cooperId = map['cooperId'],
        userId = map['userId'],
        userNome = map['userNome'];
}
