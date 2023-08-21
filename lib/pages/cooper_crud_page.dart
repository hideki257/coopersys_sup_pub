import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/cooper_crud_cont.dart';
import '../models/crud.dart';
import '../utils/resultado.dart';
import '../utils/show_meu_snackbar.dart';
import '../widgets/form_formatado.dart';
import '../widgets/meu_checkbox.dart';
import '../widgets/meu_text_form_field.dart';

// ignore: must_be_immutable
class CooperCrudPage extends ConsumerWidget {
  final CooperCrudKey cooperCrudKey;
  bool isLoading = true;

  CooperCrudPage({super.key, required this.cooperCrudKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CooperCrudCont cooperCrudCont =
        ref.watch(cooperCrudContProvider(cooperCrudKey));
    if (isLoading) {
      cooperCrudCont.refresh();
      isLoading = false;
    }
    return FormFormatado(
      formKey: cooperCrudCont.formKey,
      appBarTitulo: 'Cooperativa',
      formBody: Column(children: [
        MeuTextFormField(
          controller: cooperCrudCont.inputNome,
          isReadOnly: cooperCrudKey.crud.isNotEdit,
          labelText: 'Nome',
          validator: (value) => cooperCrudCont.validarNome(value),
        ),
        MeuCheckBox(
          value: cooperCrudCont.inputInativa,
          labelText: 'Inativa',
          isReadOnly: cooperCrudKey.crud.isNotEdit,
          onChanged: (value) => cooperCrudCont.setInativa(value),
        ),
      ]),
      onSalvar: () async {
        Resultado resultado = await cooperCrudCont.persistir();
        if (context.mounted) {
          if (resultado.validado) {
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
      },
    );
  }
}
