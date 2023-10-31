import 'package:flutter/material.dart';

import 'models/cooper.dart';
import 'models/crud.dart';
import 'pages/cooper_crud_page.dart';
import 'pages/cooper_list_page.dart';
import 'pages/cooper_user_crud.page.dart';
import 'pages/cooper_user_list_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/usuario_crud_page.dart';
import 'services/auth_service.dart';
import 'utils/minha_excecao.dart';
import 'widgets/auth_check_widget.dart';
import 'widgets/route_not_found.dart';

class MyRouterException extends MinhaExcecao {
  MyRouterException(super.message);
}

class MyRouter {
  static const initialPage = '/';
  static const homePage = '/homePage';
  static const loginPage = '/login';
  static const usuarioCrud = '/usuario/crud';
  static const cooperCrud = '/cooperativa/crud';
  static const cooperList = '/cooperativa/list';
  static const cooperUserList = '/cooperativa/crud/usuario/list';
  static const cooperUserCrud = '/cooperativa/crud/usuario/crud';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialPage:
        return MaterialPageRoute(builder: (_) => const AuthCheckWidget());
      case homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case loginPage:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case usuarioCrud:
        UsuarioCrudKey usuarioCrudKey = (settings.arguments is UsuarioCrudKey)
            ? (settings.arguments as UsuarioCrudKey)
            : UsuarioCrudKey(
                crud: Crud.read,
                userId: AuthService.usuarioId,
              );
        return MaterialPageRoute(
            builder: (_) => UsuarioCrudPage(usuarioCrudKey: usuarioCrudKey));
      case cooperList:
        return MaterialPageRoute(builder: (_) => const CooperListPage());
      case cooperCrud:
        if (settings.arguments is CooperCrudKey) {
          CooperCrudKey cooperCrudKey = settings.arguments as CooperCrudKey;
          return MaterialPageRoute(
              builder: (_) => CooperCrudPage(cooperCrudKey: cooperCrudKey));
        } else {
          throw MyRouterException('Chave inválida para Cooperativa!');
        }
      case cooperUserList:
        if (settings.arguments is Cooper) {
          Cooper cooper = settings.arguments as Cooper;
          return MaterialPageRoute(
              builder: (_) => CooperUserListPage(cooper: cooper));
        } else {
          throw MyRouterException('Chave inválida para Cooperativa!');
        }
      case cooperUserCrud:
        if (settings.arguments is CooperUserCrudKey) {
          CooperUserCrudKey cooperUserCrudKey =
              settings.arguments as CooperUserCrudKey;
          return MaterialPageRoute(
              builder: (_) =>
                  CooperUserCrudPage(cooperUserCrudKey: cooperUserCrudKey));
        } else {
          throw MyRouterException('Chave inválida para Cooperativa!');
        }
      default:
        return MaterialPageRoute(
            builder: (_) => RouteNotFound(routeName: settings.name));
    }
  }
}
