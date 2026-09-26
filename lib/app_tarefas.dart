import 'package:flutter/cupertino.dart';

import 'tema/cores_unitins.dart';
import 'telas/tela_tarefas.dart';

/// Configuracao geral do app: nome, tema e primeira tela.
class AppTarefas extends StatelessWidget {
  const AppTarefas({super.key});

  @override
  Widget build(BuildContext context) {
    // CupertinoApp usa o visual do iPhone em todas as plataformas.
    return const CupertinoApp(
      title: 'Minhas Tarefas',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CoresUnitins.azul,
        barBackgroundColor: CoresUnitins.azul,
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
      ),
      home: TelaTarefas(),
    );
  }
}
