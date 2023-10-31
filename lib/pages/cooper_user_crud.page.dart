import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/cooper_user_crud_cont.dart';
import '../models/crud.dart';
import '../models/usuario.dart';
import '../utils/resultado.dart';
import '../utils/show_meu_snackbar.dart';
import '../widgets/form_formatado.dart';
import '../widgets/meu_dropdown.dart';
import '../widgets/meu_text_form_field.dart';

// ignore: must_be_immutable
class CooperUserCrudPage extends ConsumerWidget {
  final CooperUserCrudKey cooperUserCrudKey;
  bool isLoading = true;

  CooperUserCrudPage({super.key, required this.cooperUserCrudKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cooperUserCrudCont =
        ref.watch(cooperUserCrudContProvider(cooperUserCrudKey));

    if (isLoading) {
      cooperUserCrudCont.refresh();
      isLoading = false;
    }

    return FormFormatado(
      formKey: cooperUserCrudCont.formKey,
      appBarTitulo: 'Cooperativa/Usuários - ${cooperUserCrudKey.crud.toDescr}',
      formBody: Column(children: [
        MeuTextFormField(
          controller: cooperUserCrudCont.outputCooperNome,
          labelText: 'Cooperativa',
          isReadOnly: true,
        ),
        cooperUserCrudCont.cooperUserCrudKey.crud == Crud.create
            ? MeuDropdown<Usuario>(
                labelText: 'Usuário',
                value: cooperUserCrudCont.usuarioSelected,
                items: cooperUserCrudCont.usuarios
                    .map<DropdownMenuItem<Usuario>>(
                        (Usuario usuario) => DropdownMenuItem(
                              value: usuario,
                              child: Text(usuario.getNome),
                            ))
                    .toList(),
                validator: (value) => cooperUserCrudCont.validarUsuario(value),
                onChanged: (value) {
                  if (value is Usuario) {
                    cooperUserCrudCont.setUsuario(value);
                  }
                },
                isReadOnly: cooperUserCrudCont.cooperUserCrudKey.crud.isNotNew,
              )
            : MeuTextFormField(
                controller: cooperUserCrudCont.outputUserNome,
                labelText: 'Usuário',
                isReadOnly: true,
              ),
      ]),
      onSalvar: cooperUserCrudCont.cooperUserCrudKey.crud == Crud.create
          ? (() async {
              Resultado resultado = await cooperUserCrudCont.associar();
              if (resultado.validado) {
                if (context.mounted) {
                  if (resultado.erro) {
                    showMeuSnackbar(
                      context,
                      resultado.mensagem,
                      tipoSnackBar: TipoSnackBar.erro,
                      showCloseIcon: true,
                    );
                  } else {
                    Navigator.pop(context, resultado);
                  }
                }
              }
            })
          : cooperUserCrudCont.cooperUserCrudKey.crud == Crud.delete
              ? (() async {
                  Resultado resultado = await cooperUserCrudCont.desassociar();
                  if (resultado.validado) {
                    if (context.mounted) {
                      if (resultado.erro) {
                        showMeuSnackbar(
                          context,
                          resultado.mensagem,
                          tipoSnackBar: TipoSnackBar.erro,
                          showCloseIcon: true,
                        );
                      } else {
                        Navigator.pop(context, resultado);
                      }
                    }
                  }
                })
              : null,
      salvarText: cooperUserCrudCont.cooperUserCrudKey.crud == Crud.create
          ? cooperUserCrudCont.cooperUserCrudKey.crud.toDescr
          : cooperUserCrudCont.cooperUserCrudKey.crud == Crud.delete
              ? cooperUserCrudCont.cooperUserCrudKey.crud.toDescr
              : '',
      salvarIcon: cooperUserCrudCont.cooperUserCrudKey.crud == Crud.create
          ? Icons.save
          : cooperUserCrudCont.cooperUserCrudKey.crud == Crud.delete
              ? Icons.delete
              : null,
      salvarColor: cooperUserCrudCont.cooperUserCrudKey.crud == Crud.create
          ? Colors.blueAccent
          : cooperUserCrudCont.cooperUserCrudKey.crud == Crud.delete
              ? Colors.redAccent
              : null,
      isPodeSalvar: cooperUserCrudCont.cooperUserCrudKey.crud == Crud.create ||
          cooperUserCrudCont.cooperUserCrudKey.crud == Crud.delete,
    );
  }
}
