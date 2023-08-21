import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/popup_menu_cont.dart';
import '../models/crud.dart';
import '../my_router.dart';
import '../services/auth_service.dart';
import 'wait_widget.dart';

class PopupMenuUserWidget extends ConsumerWidget {
  const PopupMenuUserWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color menuColor = Colors.black87;

    AsyncValue<PopupMenuCont> popupMenuUserCont =
        ref.watch(popupMenuContProvider);

    return popupMenuUserCont.when(
      loading: () => const WaitWidget(),
      error: (error, stackTrace) => Text('PopupMenuUserWidget-Erro:$error'),
      data: (data) {
        return PopupMenuButton(
          icon: CircleAvatar(
            backgroundColor: Colors.lightBlueAccent.shade200,
            child: Text(data.usuario.getInitials(qtd: 1)),
          ),
          onSelected: (value) async {
            switch (value) {
              case 'perfil':
                Navigator.pushNamed(
                  context,
                  MyRouter.usuarioCrud,
                  arguments: UsuarioCrudKey(
                    crud: Crud.update,
                    userId: AuthService.usuarioId,
                  ),
                );
                break;
              case 'sair':
                await data.sair();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'perfil',
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Icon(
                        Icons.account_box_outlined,
                        color: menuColor,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Center(
                      child: Text(
                        'Perfil',
                        style: TextStyle(color: menuColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'sair',
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Icon(
                        Icons.logout,
                        color: menuColor,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Center(
                      child: Text(
                        'Sair',
                        style: TextStyle(color: menuColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          position: PopupMenuPosition.under,
        );
      },
    );
  }
}
