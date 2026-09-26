import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app_tarefas.dart';

void main() {
  prepararBancoNoComputador();
  runApp(const AppTarefas());
}

/// No Android, iOS e macOS o sqflite ja funciona sozinho.
/// No Windows e no Linux ele precisa do sqflite_common_ffi.
void prepararBancoNoComputador() {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
