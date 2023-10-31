class Usuario {
  final String userId;
  String? email;
  String? phoneNumber;
  String? nome;
  DateTime? dataNascimento;
  bool inativo = false;

  String get getNome => _getNome();

  String get getInitialsDef => getInitials(qtd: 2);

  Usuario({
    required this.userId,
    this.email,
    this.phoneNumber,
    this.nome,
    this.dataNascimento,
    this.inativo = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'phoneNumber': phoneNumber,
      'nome': nome,
      'dataNascimento': dataNascimento?.millisecondsSinceEpoch,
      'inativo': inativo,
    };
  }

  Map<String, dynamic> toMapCooperUser(String cooperId) {
    return {
      'cooperId': cooperId,
      'userId': userId,
      'userNome': nome,
      'inativo': inativo,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'nome': nome,
      'dataNascimento': dataNascimento?.millisecondsSinceEpoch,
      'inativo': inativo,
    };
  }

  Usuario.fromMap(Map<String, dynamic> map)
      : userId = map['userId'],
        email = map['email'],
        phoneNumber = map['phoneNumber'],
        nome = map['nome'],
        dataNascimento = map['dataNascimento'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['dataNascimento'])
            : null,
        inativo = map['inativo'] ?? false;

  String _getNome() {
    return nome != null && nome!.trim().isNotEmpty ? nome! : email ?? userId;
  }

  String getInitials({int qtd = 2}) {
    String result = '';
    String nome = _getNome().trim().toUpperCase();
    final splited = nome.split(' ');
    for (int i = 0; i < splited.length; i++) {
      if (i >= qtd) break;
      result += splited[i][0];
    }
    return result;
  }
}
