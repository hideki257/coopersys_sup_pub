import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/usuario_data.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';

final popupMenuContProvider = FutureProvider<PopupMenuCont>((ref) async {
  PopupMenuCont popupMenuCont = PopupMenuCont(ref: ref);
  await popupMenuCont.refresh();
  return popupMenuCont;
});

class PopupMenuCont {
  final Ref ref;
  late Usuario usuario;
  PopupMenuCont({required this.ref});

  refresh() async {
    UsuarioData usuarioData = ref.read(usuarioDataProvider);
    usuario = await usuarioData.getUsuarioById(userId: AuthService.usuarioId);
  }

  sair() async {
    AuthService authService = ref.read(authServiceProvider);
    await authService.sair();
  }
}
