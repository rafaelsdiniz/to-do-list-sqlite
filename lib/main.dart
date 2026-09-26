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

/// No Android, iOS e macOS o sqflite ja funciona sozinho.
/// No navegador precisa do factory ffi web; no Windows e no Linux, do sqflite_common_ffi.
/// kIsWeb e' checado primeiro pra nunca tocar em Platform (dart:io) rodando no navegador.
void prepararBancoNoComputador() {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
