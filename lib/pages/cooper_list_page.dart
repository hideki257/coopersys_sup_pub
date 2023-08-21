import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/cooper_list_cont.dart';
import '../models/crud.dart';
import '../my_router.dart';
import '../utils/const_utils.dart';
import '../widgets/page_message_widget.dart';
import '../widgets/page_wait_widget.dart';
import '../widgets/pagina_formatada.dart';

class CooperListPage extends ConsumerWidget {
  const CooperListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String pageTitle = 'Cooperativa - Lista';
    final cooperListCont = ref.watch(cooperListContProvider);

    return cooperListCont.when(
      error: (error, stackTrace) => PageMessageWidget(
        appTitle: pageTitle,
        message: 'CooperListPage-build-error:${error.toString()}',
      ),
      loading: () => const PageWaitWidget(appTitle: pageTitle),
      data: (data) => PaginaFormatada(
        appBarTitulo: pageTitle,
        appBarActions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                MyRouter.cooperCrud,
                arguments: CooperCrudKey(crud: Crud.create),
              );
            },
          ),
        ],
        page: data.isEmpty
            ? const Center(
                child: Text('Nenhuma cooperativa encontrada!'),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: data.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(data[index].nome),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                          child: boolInativoToIconCol(data[index].inativa)),
                      Flexible(
                        child: IconButton(
                          icon: const Icon(Icons.group_outlined),
                          onPressed: () => Navigator.pushNamed(
                              context, MyRouter.cooperUserList,
                              arguments: data[index]),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MyRouter.cooperCrud,
                      arguments: CooperCrudKey(
                          crud: Crud.update, cooperId: data[index].cooperId),
                    );
                  },
                ),
              ),
      ),
    );
    /*
    return PaginaFormatada(
      appBarTitulo: ,
      appBarActions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.pushNamed(
              context,
              MyRouter.cooperCrud,
              arguments: CooperCrudKey(crud: Crud.create),
            ).then((value) async {
              if (value is Resultado && value.ok) {
                await cooperListCont.refresh();
              }
            });
          },
        ),
      ],
      page: cooperListCont.coopers.isEmpty
          ? const Center(
              child: Text('Nenhuma cooperativa encontrada!'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: cooperListCont.coopers.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(cooperListCont.coopers[index].nome),
                trailing:
                    boolInativoToIconCol(cooperListCont.coopers[index].inativa),
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    MyRouter.cooperCrud,
                    arguments: CooperCrudKey(
                        crud: Crud.update,
                        cooperId: cooperListCont.coopers[index].cooperId),
                  ).then((value) async {
                    if (value is Resultado && value.ok) {
                      await cooperListCont.refresh();
                    }
                  });
                },
              ),
            ),
    );
    */
  }
}
