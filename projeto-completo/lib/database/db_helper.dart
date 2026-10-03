import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tarefa.dart';

/// Toda a conversa com o banco de dados acontece aqui.
/// A tela nunca escreve SQL: ela só chama inserir, listar, atualizar e excluir.
class DBHelper {
  // O construtor é privado (o "_") e existe uma instância só, a "instance".
  // Assim o app inteiro usa o mesmo DBHelper e a mesma conexão com o banco.
  // Esse jeito de fazer tem nome: singleton.
  DBHelper._();
  static final DBHelper instance = DBHelper._();

  static const _nomeArquivo = 'tarefas.db';
  static const _versao = 1; // se um dia a tabela mudar, essa versão sobe para 2
  static const tabela = 'tarefas';

  Database? _db;

  /// Na primeira vez que alguém pede o banco, ele é aberto.
  /// Nas próximas vezes, devolvemos o mesmo que já está aberto.
  Future<Database> get database async {
    _db ??= await _abrirBanco();
    return _db!;
  }

  Future<Database> _abrirBanco() async {
    // getDatabasesPath() diz em qual pasta o sistema guarda os bancos.
    // O join junta essa pasta com o nome do arquivo.
    final caminho = join(await getDatabasesPath(), _nomeArquivo);
    return openDatabase(
      caminho,
      version: _versao,
      // O onCreate só roda se o arquivo ainda não existe,
      // ou seja, na primeira vez que o app é aberto.
      onCreate: _criarTabelas,
    );
  }

  Future<void> _criarTabelas(Database banco, int versao) async {
    // id: o próprio banco numera as tarefas (1, 2, 3...) por causa do AUTOINCREMENT.
    // concluida: é INTEGER porque o SQLite não tem booleano (0 = pendente, 1 = feita).
    await banco.execute('''
      CREATE TABLE $tabela (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT NOT NULL,
        concluida INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  /// Grava uma tarefa nova (o C do CRUD) e devolve o id que o banco deu para ela.
  Future<int> inserir(Tarefa tarefa) async {
    final banco = await database;
    // Tiramos o id do Map porque quem escolhe o id é o banco.
    final dados = tarefa.toMap()..remove('id');
    return banco.insert(tabela, dados);
  }

  /// Busca todas as tarefas (o R do CRUD).
  /// As pendentes vêm primeiro, e as mais novas ficam no topo.
  Future<List<Tarefa>> listar() async {
    final banco = await database;
    final linhas = await banco.query(tabela, orderBy: 'concluida ASC, id DESC');
    // Cada linha chega como um Map, e o fromMap transforma em Tarefa.
    return linhas.map(Tarefa.fromMap).toList();
  }

  /// Salva a mudança de uma tarefa que já existe (o U do CRUD).
  /// A gente usa para marcar como concluída ou pendente.
  Future<int> atualizar(Tarefa tarefa) async {
    final banco = await database;
    return banco.update(
      tabela,
      tarefa.toMap(),
      // O "?" é trocado pelo valor do whereArgs. Nunca monte o SQL juntando
      // texto, tipo 'id = ' + id: isso abre a porta para SQL Injection.
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  /// Apaga a tarefa com esse id (o D do CRUD).
  Future<int> excluir(int id) async {
    final banco = await database;
    return banco.delete(tabela, where: 'id = ?', whereArgs: [id]);
  }
}
