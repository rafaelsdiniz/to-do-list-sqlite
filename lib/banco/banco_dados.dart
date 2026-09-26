import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../modelos/tarefa.dart';

/// Unico lugar do app que conhece SQL.
/// As telas so chamam os metodos daqui.
class BancoDados {
  // Singleton: uma unica instancia e uma unica conexao aberta.
  BancoDados._();
  static final BancoDados instancia = BancoDados._();

  static const _nomeArquivo = 'tarefas.db';
  static const _versao = 1;
  static const tabela = 'tarefas';

  Database? _conexao;

  /// Abre o banco na primeira chamada e reaproveita nas proximas.
  Future<Database> get conexao async {
    _conexao ??= await _abrirBanco();
    return _conexao!;
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
    await banco.execute('''
      CREATE TABLE $tabela (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT NOT NULL,
        concluida INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // CREATE
  Future<int> inserir(Tarefa tarefa) async {
    final banco = await conexao;
    final dados = tarefa.paraMapa()..remove('id'); // o banco gera o id
    return banco.insert(tabela, dados);
  }

  // READ
  Future<List<Tarefa>> listar() async {
    final banco = await conexao;
    // Pendentes primeiro, mais novas no topo.
    final linhas = await banco.query(tabela, orderBy: 'concluida ASC, id DESC');
    return linhas.map(Tarefa.doMapa).toList();
  }

  // UPDATE
  Future<int> atualizar(Tarefa tarefa) async {
    final banco = await conexao;
    return banco.update(
      tabela,
      tarefa.paraMapa(),
      where: 'id = ?',
      whereArgs: [tarefa.id], // sempre usar ? e whereArgs, nunca concatenar
    );
  }

  // DELETE
  Future<int> excluir(int id) async {
    final banco = await conexao;
    return banco.delete(tabela, where: 'id = ?', whereArgs: [id]);
  }
}
