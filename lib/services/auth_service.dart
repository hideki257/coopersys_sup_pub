import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/minha_excecao.dart';

class AuthServiceExcetpion extends MinhaExcecao {
  AuthServiceExcetpion(super.message);
}

final authServiceProvider =
    ChangeNotifierProvider<AuthService>((ref) => AuthService.get());

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._();

  static get() {
    return AuthService._instance;
  }

  bool isLoading = true;
  bool isAuthenticated = false;
  User? user;

  static String get usuarioId {
    User? user = AuthService._instance.user;
    if (user != null) {
      return user.uid;
    } else {
      throw AuthServiceExcetpion('Usuário não autenticado!');
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService._() {
    _initAuthData();
  }

  _initAuthData() {
    _getUser();
  }

  entrarComEmailESenha(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(email: email, password: senha);
    _getUser();
  }

  criarComEmailESenha(String email, String senha) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: senha);
    _getUser();
  }

  sair() async {
    await _auth.signOut().then((_) {
      isAuthenticated = false;
    });
    _getUser();
  }

  _getUser() {
    isLoading = true;
    isAuthenticated = false;
    user = _auth.currentUser;
    if (user != null) {
      isAuthenticated = true;
    }
    isLoading = false;
    notifyListeners();
  }
}
