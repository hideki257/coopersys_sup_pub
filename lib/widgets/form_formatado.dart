import 'package:flutter/material.dart';

import '../utils/const_utils.dart';
import 'menu_widget.dart';

class FormFormatado extends StatelessWidget {
  final String? appBarTitulo;
  final bool showMenu;
  final List<Widget>? appBarActions;
  final GlobalKey<FormState> formKey;
  final Widget formBody;
  final double maxWidth;
  final VoidCallback? onSalvar;
  final String salvarText;
  final IconData? salvarIcon;
  final Key? scaffoldKey;
  final VoidCallback? onLeftButton;
  final String leftButtonText;
  final IconData? leftButtonIcon;
  final VoidCallback? onMiddleButton;
  final String middleButtonText;
  final IconData? middleButtonIcon;
  final Color? salvarColor;
  final Color? leftButtonColor;
  final Color? middleButtonColor;
  final bool isButtonApagar;
  final bool isPodeSalvar;

  const FormFormatado({
    Key? key,
    this.scaffoldKey,
    this.appBarTitulo,
    this.showMenu = false,
    this.appBarActions,
    required this.formKey,
    required this.formBody,
    this.maxWidth = 1000, //double.infinity,
    this.onSalvar,
    this.salvarText = '',
    this.salvarIcon,
    this.salvarColor,
    this.onLeftButton,
    this.leftButtonText = 'Botão 1',
    this.leftButtonIcon,
    this.leftButtonColor,
    this.onMiddleButton,
    this.middleButtonText = 'Botão 2',
    this.middleButtonIcon,
    this.middleButtonColor,
    this.isButtonApagar = false,
    this.isPodeSalvar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (buildContext, constraints) {
      final isMobile = isWidthMobile(constraints.maxWidth);
      List<Widget>? appBarActions = this.appBarActions;

      return Scaffold(
        key: scaffoldKey,
        drawer: isMobile && showMenu ? MenuWidget(isMobile: isMobile) : null,
        appBar: (appBarTitulo == null)
            ? null
            : AppBar(
                title: Text(appBarTitulo ?? ''),
                actions: appBarActions,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.indigoAccent.shade400,
                        Colors.indigoAccent.shade100,
                      ],
                    ),
                  ),
                ),
              ),
        body: isMobile || !showMenu
            ? body(isMobile: isMobile)
            : Row(
                children: [
                  MenuWidget(isMobile: isMobile),
                  body(isMobile: isMobile),
                ],
              ),
      );
    });
  }

  Widget body({required bool isMobile}) {
    String salvarText = this.salvarText.isNotEmpty
        ? this.salvarText
        : isButtonApagar
            ? 'Apagar'
            : 'Salvar';
    IconData? salvarIcon = this.salvarIcon ??
        (isButtonApagar ? Icons.delete_outline : Icons.save_outlined);

    Color? salvarColor =
        this.salvarColor ?? (isButtonApagar ? Colors.red : Colors.green);

    return SingleChildScrollView(
      child: Container(
        alignment: isMobile ? Alignment.topCenter : Alignment.topLeft,
        padding: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            padding: const EdgeInsets.all(8),
            child: Form(
              key: formKey,
              child: (onSalvar == null &&
                      onLeftButton == null &&
                      onMiddleButton == null)
                  ? formBody
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        formBody,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              onLeftButton != null
                                  ? Flexible(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: leftButtonIcon == null
                                            ? ElevatedButton(
                                                onPressed: onLeftButton,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      leftButtonColor,
                                                ),
                                                child: Text(leftButtonText),
                                              )
                                            : ElevatedButton.icon(
                                                onPressed: onLeftButton,
                                                icon: Icon(leftButtonIcon,
                                                    color: leftButtonColor),
                                                label: Text(leftButtonText),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      leftButtonColor,
                                                ),
                                              ),
                                      ),
                                    )
                                  : Container(),
                              onMiddleButton != null
                                  ? Flexible(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: middleButtonIcon != null
                                            ? ElevatedButton.icon(
                                                onPressed: onMiddleButton,
                                                icon: Icon(middleButtonIcon),
                                                label: Text(middleButtonText),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        middleButtonColor),
                                              )
                                            : ElevatedButton(
                                                onPressed: onMiddleButton,
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        middleButtonColor),
                                                child: Text(middleButtonText),
                                              ),
                                      ),
                                    )
                                  : Container(),
                              (onSalvar != null && isPodeSalvar)
                                  ? Flexible(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton.icon(
                                          onPressed: onSalvar,
                                          icon: Icon(salvarIcon),
                                          label: Text(salvarText),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: salvarColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
