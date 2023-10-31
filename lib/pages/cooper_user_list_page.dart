import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/cooper_user_list_cont.dart';
import '../models/cooper.dart';
import '../models/crud.dart';
import '../my_router.dart';
import '../widgets/meu_text_form_field.dart';
import '../widgets/page_message_widget.dart';
import '../widgets/page_wait_widget.dart';
import '../widgets/pagina_formatada.dart';

class CooperUserListPage extends ConsumerWidget {
  final Cooper cooper;
  const CooperUserListPage({super.key, required this.cooper});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cooperUserListCont = ref.watch(cooperUserListContProvider(cooper));
    const String appTitle = 'Usuários da Cooperativa';

    return cooperUserListCont.when(
      error: (error, stackTrace) => PageMessageWidget(
        appTitle: appTitle,
        message: error.toString(),
      ),
      loading: () => const PageWaitWidget(
        appTitle: appTitle,
      ),
      data: (data) => PaginaFormatada(
        appBarTitulo: appTitle,
        appBarActions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                MyRouter.cooperUserCrud,
                arguments: CooperUserCrudKey(
                    crud: Crud.create, cooperId: cooper.cooperId, userId: null),
              );
            },
          ),
        ],
        page: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MeuTextFormField(
                labelText: 'Cooperativa',
                initialText: cooper.nome,
                isReadOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flexible(
                child: data.isEmpty
                    ? const Center(
                        child: Text('Nenhum usuário vinculado!'),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8.0),
                            itemCount: data.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) => ListTile(
                              title: Text(data[index].userNome),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  MyRouter.cooperUserCrud,
                                  arguments: CooperUserCrudKey(
                                    crud: Crud.delete,
                                    cooperId: data[index].cooperId,
                                    userId: data[index].userId,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
