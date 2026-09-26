import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'telas/tela_tarefas.dart';

void main() {
  // No Android, iOS e macOS o sqflite ja funciona sozinho.
  // No Windows e no Linux ele precisa do sqflite_common_ffi.
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const AppTarefas());
}

class AppTarefas extends StatelessWidget {
  const AppTarefas({super.key});

  @override
  Widget build(BuildContext context) {
    // CupertinoApp usa o visual do iPhone em todas as plataformas.
    return const CupertinoApp(
      title: 'Minhas Tarefas',
      debugShowCheckedModeBanner: false,
      home: TelaTarefas(),
    );
  }
}
