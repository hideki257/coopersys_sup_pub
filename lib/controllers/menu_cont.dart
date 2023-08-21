import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/usuario_data.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';

final menuContProvider = FutureProvider<MenuCont>((ref) async {
  MenuCont menuCont = MenuCont(ref: ref);
  await menuCont.refresh();
  return menuCont;
});

class MenuCont {
  final Ref ref;
  Usuario? usuario;

  MenuCont({required this.ref}) {
    refresh();
  }

  refresh() async {
    UsuarioData usuarioData = ref.read(usuarioDataProvider);
    usuario = await usuarioData.getUsuarioById(userId: AuthService.usuarioId);
  }

  sair() async {
    AuthService authService = ref.read(authServiceProvider);
    await authService.sair();
  }
}
