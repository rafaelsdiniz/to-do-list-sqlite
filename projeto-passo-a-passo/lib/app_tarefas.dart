import 'package:flutter/cupertino.dart';

import 'tema/cores_unitins.dart';
import 'telas/tela_tarefas.dart';

/// A "casca" do app: o nome, as cores e qual tela abre primeiro.
class AppTarefas extends StatelessWidget {
  const AppTarefas({super.key});

  @override
  Widget build(BuildContext context) {
    // Com o CupertinoApp o app fica com cara de iPhone,
    // mesmo rodando no Windows ou no Android.
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
