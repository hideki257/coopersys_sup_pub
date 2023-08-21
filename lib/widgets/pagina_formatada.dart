import 'package:flutter/material.dart';

import '../utils/const_utils.dart';
import 'menu_widget.dart';

class PaginaFormatada extends StatelessWidget {
  final Key? scaffoldKey;
  final String? appBarTitulo;
  final List<Widget>? appBarActions;
  final bool showMenu;
  final double maxWidth;
  final Widget page;
  final Widget? floatingActionButton;
  final bool isHomePage;
  const PaginaFormatada({
    Key? key,
    this.scaffoldKey,
    this.appBarTitulo,
    this.appBarActions,
    required this.page,
    this.showMenu = false,
    this.maxWidth = 1000, //double.infinity,
    this.floatingActionButton,
    this.isHomePage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (contextBuilder, constraints) {
      final isMobile = isWidthMobile(constraints.maxWidth);
      return Scaffold(
        key: scaffoldKey,
        drawer: isMobile && showMenu ? MenuWidget(isMobile: isMobile) : null,
        appBar: !isMobile
            ? AppBar(title: const Text(titlePage))
            : (appBarTitulo != null && appBarTitulo!.trim().isNotEmpty)
                ? AppBar(
                    title: Text(appBarTitulo!),
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
                  )
                : null,
        body: Container(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
          ),
          alignment: isMobile ? Alignment.topCenter : Alignment.topLeft,
          child: isMobile
              ? page
              : !showMenu
                  ? (appBarTitulo != null &&
                          appBarTitulo!.isNotEmpty &&
                          !isHomePage)
                      ? //page
                      Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Flexible(child: Container()),
                                    Flexible(
                                      child: Center(
                                        child: Text(
                                          appBarTitulo!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: appBarActions!)),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(child: page),
                          ],
                        )
                      : page
                  : (appBarTitulo != null &&
                          appBarTitulo!.isNotEmpty &&
                          !isHomePage)
                      ? Row(
                          children: [
                            MenuWidget(isMobile: isMobile),
                            Flexible(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          appBarTitulo!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  page,
                                ],
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            MenuWidget(isMobile: isMobile),
                            Flexible(
                              child: page,
                            ),
                          ],
                        ),
        ),
        floatingActionButton: floatingActionButton,
      );
    });
  }
}
