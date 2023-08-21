enum Crud {
  create,
  read,
  update,
  delete,
}

extension CrudExt on Crud {
  String _toDescr() {
    switch (this) {
      case Crud.create:
        return 'Criar';
      case Crud.read:
        return 'Ver';
      case Crud.update:
        return 'Alterar';
      case Crud.delete:
        return 'Apagar';
    }
  }

  String _toMap() {
    switch (this) {
      case Crud.create:
        return 'create';
      case Crud.read:
        return 'read';
      case Crud.update:
        return 'update';
      case Crud.delete:
        return 'delete';
    }
  }

  String get toDescr => _toDescr();
  String get toMap => _toMap();

  bool get isNew => this == Crud.create;
  bool get isNotNew => !isNew;

  bool get isAction =>
      this == Crud.create || this == Crud.update || this == Crud.delete;
  bool get isNotAction => !isAction;

  bool get isEdit => this == Crud.create || this == Crud.update;
  bool get isNotEdit => !isEdit;
}

extension StringCrudExt on String {
  Crud _toCrud() {
    switch (trim().toLowerCase()) {
      case 'create':
        return Crud.create;
      case 'read':
        return Crud.read;
      case 'update':
        return Crud.update;
      case 'delete':
        return Crud.delete;
      default:
        return Crud.read;
    }
  }

  Crud get toCrud => _toCrud();
}

List<Crud> listaCrud = [Crud.read, Crud.create, Crud.update, Crud.delete];

class UsuarioCrudKey {
  Crud crud;
  String userId;
  UsuarioCrudKey({required this.crud, required this.userId});
}

class CooperCrudKey {
  Crud crud;
  String? cooperId;
  CooperCrudKey({required this.crud, this.cooperId});
}

class CooperUserCrudKey {
  Crud crud;
  String? cooperId;
  String? userId;
  CooperUserCrudKey({required this.crud, this.cooperId, this.userId});
}
