import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/login_cont.dart';
import '../utils/resultado.dart';
import '../widgets/form_formatado.dart';
import '../widgets/meu_text_form_field.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginCont = ref.watch(loginContProvider);
    return FormFormatado(
      formKey: loginCont.formKey,
      maxWidth: 450,
      formBody: loginCont.isLogin
          ? Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MeuTextFormField(
                  controller: loginCont.inputLogEmail,
                  labelText: 'Email',
                  validator: (value) => loginCont.validarEmail(value),
                ),
                MeuTextFormField(
                  controller: loginCont.inputLogSenha,
                  labelText: 'Senha',
                  validator: (value) => loginCont.validarSenha(value),
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Entrar'),
                    onPressed: () async {
                      Resultado res = await loginCont.entrar();
                      if (res.validado && res.erro) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(res.mensagem),
                              showCloseIcon: true));
                        }
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () => loginCont.toggleLogCad(),
                    child: const Center(
                      child: Text(
                        'Não sou cadastrado. Cadastrar...',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Cadastrar',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MeuTextFormField(
                  controller: loginCont.inputCadEmail,
                  labelText: 'Email',
                  validator: (value) => loginCont.validarEmail(value),
                ),
                MeuTextFormField(
                  controller: loginCont.inputCadSenha,
                  labelText: 'Senha',
                  obscureText: true,
                  validator: (value) => loginCont.validarCadSenha(value),
                ),
                MeuTextFormField(
                  controller: loginCont.inputCadConfSen,
                  labelText: 'Confirmação de senha',
                  obscureText: true,
                  validator: (value) => loginCont.validarCadConfSen(value),
                ),
                MeuTextFormField(
                  controller: loginCont.inputCadNome,
                  labelText: 'Nome',
                  validator: (value) => loginCont.validarNome(value),
                ),
                //TextFormField(
                MeuTextFormField(
                  controller: loginCont.outputCadDataNasc,
                  labelText: 'Data de nascimento',
                  onTap: () async {
                    DateTime? dataAux = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 120),
                      lastDate: DateTime.now(),
                    );
                    loginCont.setDataNascimento(dataAux);
                  },
                  isData: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Cadastrar'),
                    onPressed: () async {
                      Resultado res = await loginCont.cadastrar();
                      if (res.validado && res.erro) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(res.mensagem),
                              showCloseIcon: true));
                        }
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () => loginCont.toggleLogCad(),
                    child: const Center(
                      child: Text(
                        'Já sou cadastrado. Entrar...',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
