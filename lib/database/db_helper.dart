import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tarefa.dart';

/// Unico lugar do app que conhece SQL.
/// As telas so chamam os metodos daqui.
class DBHelper {
  // Singleton: uma unica instancia e uma unica conexao aberta.
  DBHelper._();
  static final DBHelper instance = DBHelper._();

  static const _nomeArquivo = 'tarefas.db';
  static const _versao = 1;
  static const tabela = 'tarefas';

  Database? _db;

  /// Abre o banco na primeira chamada e reaproveita nas proximas.
  Future<Database> get database async {
    _db ??= await _abrirBanco();
    return _db!;
  }

  Future<Database> _abrirBanco() async {
    final caminho = join(await getDatabasesPath(), _nomeArquivo);
    return openDatabase(
      caminho,
      version: _versao,
      onCreate: _criarTabelas, // roda so quando o arquivo .db ainda nao existe
    );
  }

  Future<void> _criarTabelas(Database banco, int versao) async {
    // TODO(Passo 2): criar a tabela com banco.execute(...) e um CREATE TABLE.
    // Colunas: id (chave, gerada pelo banco), descricao (texto) e
    // concluida (inteiro, 0 ou 1).
    throw UnimplementedError('Passo 2: escrever o CREATE TABLE');
  }

  // CREATE
  Future<int> inserir(Tarefa tarefa) async {
    // TODO(Passo 3): gravar com banco.insert(...). Tirar o id do Map,
    // porque quem gera o id e o banco.
    throw UnimplementedError('Passo 3: escrever o inserir()');
  }

  // READ
  Future<List<Tarefa>> listar() async {
    // TODO(Passo 3): ler com banco.query(...), pendentes primeiro, e
    // converter cada linha com Tarefa.fromMap.
    throw UnimplementedError('Passo 3: escrever o listar()');
  }

  // UPDATE
  Future<int> atualizar(Tarefa tarefa) async {
    // TODO(Passo 3): atualizar com banco.update(...) usando where e whereArgs.
    throw UnimplementedError('Passo 3: escrever o atualizar()');
  }

  // DELETE
  Future<int> excluir(int id) async {
    // TODO(Passo 3): apagar com banco.delete(...) usando where e whereArgs.
    throw UnimplementedError('Passo 3: escrever o excluir()');
  }
}
