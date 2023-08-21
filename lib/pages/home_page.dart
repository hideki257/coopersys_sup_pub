import 'package:flutter/material.dart';

import '../utils/const_utils.dart';
import '../widgets/pagina_formatada.dart';
import '../widgets/popup_menu_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return PaginaFormatada(
      appBarTitulo: titlePage,
      page: GridView.count(
        crossAxisCount: 1,
        children: const [
          Text(''),
        ],
      ),
      showMenu: true,
      appBarActions: const [PopupMenuUserWidget()],
      isHomePage: true,
    );
  }
}
