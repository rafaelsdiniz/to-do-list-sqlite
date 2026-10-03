import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'app_tarefas.dart';

void main() {
  prepararBancoNoComputador();
  runApp(const AppTarefas());
}

/// O sqflite foi feito pensando em celular. No Android, no iPhone e no Mac
/// ele já funciona sem a gente configurar nada.
///
/// No Windows, no Linux e no navegador ele precisa de uma ajuda: trocamos o
/// databaseFactory (quem abre o banco) por uma versão que sabe rodar ali.
///
/// O kIsWeb vem primeiro de propósito. No navegador não existe Platform, então
/// perguntar "Platform.isWindows" lá faria o app quebrar.
void prepararBancoNoComputador() {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
