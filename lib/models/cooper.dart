import 'package:uuid/uuid.dart';

class Cooper {
  late String cooperId;
  final String nome;
  final bool inativa;

  Cooper({String? cooperId, required this.nome, this.inativa = false}) {
    if (cooperId == null || cooperId.isEmpty) {
      const uuid = Uuid();
      this.cooperId = uuid.v4();
    } else {
      this.cooperId = cooperId;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'cooperId': cooperId,
      'nome': nome,
      'inativa': inativa,
    };
  }

  Map<String, dynamic> toMapUserCooper(String userId) {
    return {
      'cooperId': cooperId,
      'userId': userId,
      'cooperNome': nome,
    };
  }

  Cooper.fromMap(Map<String, dynamic> map)
      : cooperId = map['cooperId'],
        nome = map['nome'],
        inativa = map['inativa'];
}
